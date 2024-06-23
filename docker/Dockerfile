# 使用基础镜像
FROM alpine:latest

# 安装必要的软件包
RUN apk update && apk add --no-cache \
  nginx \
  sshfs \
  && rm -rf /var/cache/apk/*

# 复制 nginx 配置文件
COPY nginx.conf /etc/nginx/nginx.conf
COPY nginx-default.conf /etc/nginx/conf.d/default.conf

# 复制 entrypoint.sh
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 复制 clear.sh
COPY clear.sh /clear.sh
RUN chmod +x /clear.sh

# 暴露 nginx 端口
EXPOSE 80

# 设置入口点
ENTRYPOINT ["/entrypoint.sh"]