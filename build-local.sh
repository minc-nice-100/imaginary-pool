#!/bin/bash

# 设置变量
IMAGE_NAME="ghcr.io/$(git config user.name)/imaginary-pool"
TAG="latest"

# 构建镜像
docker build -t $IMAGE_NAME:$TAG .

# 登录GHCR
echo $GHCR_TOKEN | docker login ghcr.io -u $(git config user.name) --password-stdin

# 推送镜像
docker push $IMAGE_NAME:$TAG

echo "镜像已发布: $IMAGE_NAME:$TAG"
