#!/bin/sh

set -e

# 检查所有必需的环境变量是否设置
: "${SFTP_USER:?需要设置 SFTP_USER}"
: "${SFTP_PASSWORD:?需要设置 SFTP_PASSWORD}"
: "${SFTP_SERVER:?需要设置 SFTP_SERVER}"
: "${SFTP_REMOTE_DIR:?需要设置 SFTP_REMOTE_DIR}"
: "${SFTP_MOUNT_POINT:?需要设置 SFTP_MOUNT_POINT}"

# 创建挂载目标目录
mkdir -p "$SFTP_MOUNT_POINT"

# 使用 sshfs 挂载 SFTP 服务器
echo $SFTP_PASSWORD | sshfs -o StrictHostKeyChecking=no,UserKnownHostsFile=/dev/null,password_stdin $SFTP_USER@$SFTP_SERVER:$SFTP_REMOTE_DIR $SFTP_MOUNT_POINT

# 判断是否需要启动 crontab
if [ -n "$SFTP_RETAIN_DAYS" ]; then
  # 配置 crontab 以每天午夜运行删除脚本
  echo "0 0 * * * /app/clear.sh" >> /etc/crontabs/root
  # 启动 cron 服务
  crond
fi

# 保持容器运行
tail -f /dev/null