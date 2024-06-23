#!/bin/sh

set -e

# 检查所有必需的环境变量是否设置
: "${SFTP_USER:?需要设置 SFTP_USER}"
: "${SFTP_PASSWORD:?需要设置 SFTP_PASSWORD}"
: "${SFTP_SERVER:?需要设置 SFTP_SERVER}"
: "${SFTP_REMOTE_DIR:?需要设置 SFTP_REMOTE_DIR}"

# 创建挂载目标目录
mkdir -p /mnt/sftp

# 使用 sshfs 挂载 SFTP 服务器
echo $SFTP_PASSWORD | sshfs -o StrictHostKeyChecking=no,UserKnownHostsFile=/dev/null,password_stdin $SFTP_USER@$SFTP_SERVER:$SFTP_REMOTE_DIR /mnt/sftp

# 判断是否需要启动 crontab
if [ -n "$SFTP_RETAIN_DAYS" ]; then
  echo "Starting cron as SFTP_RETAIN_DAYS is set to $SFTP_RETAIN_DAYS"
  # 配置 crontab 以每天午夜运行删除脚本
  echo "0 0 * * * /clear.sh" >> /etc/crontabs/root
  # 启动 cron 服务
  crond
else
  echo "SFTP_RETAIN_DAYS is not set, skipping cron start"
fi

# 启动 nginx 服务
echo "Starting nginx"
nginx -g 'daemon off;'