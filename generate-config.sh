#!/bin/bash

# 读取环境变量
POOL_SIZE=${POOL_SIZE:-3}
H2O_PORT=${H2O_PORT:-8080}

# 生成H2O配置文件
cat > /etc/h2o/h2o.conf << EOF
listen: $H2O_PORT
hosts:
  default:
    paths:
      /:
        proxy.reverse.url:
EOF

# 添加后端服务器配置
for i in $(seq 1 $POOL_SIZE); do
    port=$((9000 + i - 1))
    echo "          - http://127.0.0.1:$port/" >> /etc/h2o/h2o.conf
done

cat >> /etc/h2o/h2o.conf << EOF
        proxy.preserve-host: OFF

access-log: /var/log/h2o/access.log
error-log: /var/log/h2o/error.log
pid-file: /var/run/h2o.pid
EOF

echo "H2O配置文件已生成，池大小: $POOL_SIZE"
