FROM alpine:3.18 AS h2o-builder

# 安装构建工具
RUN apk add --no-cache \
    git \
    cmake \
    make \
    gcc \
    g++ \
    openssl-dev \
    libuv-dev \
    wslay-dev \
    zlib-dev

# 克隆并构建H2O（使用特定版本避免构建问题）
RUN git clone --depth 1 --branch v2.2.6 https://github.com/h2o/h2o.git /tmp/h2o && \
    cd /tmp/h2o && \
    cmake -DWITH_BUNDLED_SSL=on . && \
    make h2o

FROM alpine:3.18 AS imaginary-builder

# 安装Go和构建工具
RUN apk add --no-cache \
    go \
    git \
    build-base \
    pkgconfig \
    imagemagick-dev \
    libjpeg-turbo-dev \
    libpng-dev

# 设置Go环境
ENV GOPATH=/go
ENV PATH=$PATH:/go/bin

# 克隆并构建imaginary
RUN git clone --depth 1 https://github.com/h2non/imaginary.git /tmp/imaginary && \
    cd /tmp/imaginary && \
    go build -ldflags="-s -w" -o imaginary .

FROM alpine:3.18

# 安装运行时依赖
RUN apk add --no-cache \
    bash \
    curl \
    imagemagick \
    libjpeg-turbo \
    libpng

# 复制H2O二进制文件
COPY --from=h2o-builder /tmp/h2o/h2o /usr/local/bin/h2o

# 复制imaginary二进制文件
COPY --from=imaginary-builder /tmp/imaginary/imaginary /usr/local/bin/imaginary

# 创建配置和脚本目录
RUN mkdir -p /etc/h2o /var/log/h2o /app/scripts

# 复制配置脚本
COPY start.sh generate-config.sh /app/scripts/
RUN chmod +x /app/scripts/*.sh

# 复制H2O配置文件模板
COPY config/h2o.conf.template /etc/h2o/

# 设置环境变量默认值
ENV POOL_SIZE=3
ENV IMAGINARY_PORT=9000
ENV H2O_PORT=8080
ENV IMAGINARY_CONFIG=""

# 暴露H2O端口
EXPOSE 8080

# 健康检查
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/ || exit 1

# 启动脚本
CMD ["/app/scripts/start.sh"]