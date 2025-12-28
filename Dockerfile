FROM h2o/h2o:latest as h2o
FROM h2non/imaginary:latest

# 安装必要的工具
RUN apk add --no-cache bash curl

# 复制H2O二进制文件
COPY --from=h2o /usr/local/bin/h2o /usr/local/bin/h2o

# 创建配置和脚本目录
RUN mkdir -p /etc/h2o /var/log/h2o /app/scripts

# 复制配置脚本
COPY scripts/ /app/scripts/
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

# 启动脚本
CMD ["/app/scripts/start.sh"]