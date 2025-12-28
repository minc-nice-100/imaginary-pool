#!/bin/bash

# 构建镜像
docker build -t imaginary-pool .

# 运行容器
docker run -d \
  --name imaginary-pool \
  -p 8080:8080 \
  -e POOL_SIZE=3 \
  -e IMAGINARY_CONFIG="-concurrency 10" \
  imaginary-pool

echo "容器已启动，访问 http://localhost:8080"
