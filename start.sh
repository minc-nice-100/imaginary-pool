#!/bin/bash

# 生成H2O配置文件
/app/scripts/generate-config.sh

# 启动imaginary实例池
for i in $(seq 1 $POOL_SIZE); do
    port=$((IMAGINARY_PORT + i - 1))
    echo "启动imaginary实例 $i, 端口: $port"
    
    # 解析环境变量配置
    if [ -n "$IMAGINARY_CONFIG" ]; then
        eval "imaginary $IMAGINARY_CONFIG -port $port" &
    else
        imaginary -port $port &
    fi
done

# 等待imaginary实例启动
sleep 3

# 启动H2O负载均衡器
echo "启动H2O负载均衡器，端口: $H2O_PORT"
h2o -c /etc/h2o/h2o.conf

# 保持容器运行
wait
