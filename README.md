# Imaginary Pool

基于H2O负载均衡器的h2non/imaginary容器池化系统。

## 快速开始

```bash
docker run -d -p 8080:8080 ghcr.io/your-username/imaginary-pool:latest
```

## 环境变量

- `POOL_SIZE`: 池化实例数量 (默认: 3)
- `H2O_PORT`: H2O负载均衡器端口 (默认: 8080)  
- `IMAGINARY_CONFIG`: imaginary配置参数

## 示例

```bash
# 使用5个实例
docker run -d -p 8080:8080 -e POOL_SIZE=5 ghcr.io/your-username/imaginary-pool:latest

# 自定义配置
docker run -d -p 8080:8080 -e POOL_SIZE=3 -e IMAGINARY_CONFIG="-concurrency 20" ghcr.io/your-username/imaginary-pool:latest
```

## GitHub Packages

镜像发布在: `ghcr.io/your-username/imaginary-pool:latest`
