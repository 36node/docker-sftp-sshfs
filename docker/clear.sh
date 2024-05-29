#!/bin/sh

# 打印开始清理的日志
echo "Starting cleanup of files older than $SFTP_RETAIN_DAYS days."

# 删除早于 SFTP_RETAIN_DAYS 天的文件
find /mnt/sftp -type f -mtime +$SFTP_RETAIN_DAYS -delete

# 打印清理完成的日志
echo "Cleanup completed."