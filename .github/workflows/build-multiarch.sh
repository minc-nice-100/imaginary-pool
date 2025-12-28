#!/bin/bash

# 设置变量
IMAGE_NAME="ghcr.io/$(git config user.name)/imaginary-pool"
PLATFORMS="linux/amd64,linux/arm64"

# 创建构建器实例
docker buildx create --name multiarch --use
docker buildx inspect --bootstrap

# 构建多架构镜像
docker buildx build \
  --platform $PLATFORMS \
  --tag $IMAGE_NAME:latest \
  --push .

echo "多架构镜像已发布: $IMAGE_NAME:latest"
echo "支持的架构: $PLATFORMS"
