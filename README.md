# docker-sftp-sshfs

A docker image for mount sftp as a local folder with sshfs

## docker-compose 

```yaml
version: '3.8'

services:
  nginx:
    image: nginx:latest
    ports:
      - "80:80"
    volumes:
      - sftp_mount:/usr/share/nginx/html/images
    depends_on:
      - sftp

  sftp:
    image: your_registry/sftp-sshfs
    privileged: true
    volumes:
      - sftp_mount:/mnt/sftp
    environment:
      - SFTP_USER=sftp_user
      - SFTP_PASSWORD=sftp_password
      - SFTP_SERVER=sftp.example.com
      - SFTP_REMOTE_DIR=/remote/directory

volumes:
  sftp_mount:
```

## k8s usage

If you want to start an nginx server to serve files in a sftp server.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-sftp-server
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx-sftp
  template:
    metadata:
      labels:
        app: nginx-sftp
    spec:
      initContainers:
      - name: sftp-mount
        image: 36node/sftp-sshfs:latest
        securityContext:
          privileged: true
        volumeMounts:
        - name: sftp-mount
          mountPath: /mnt/sftp
        env:
        - name: SFTP_USER
          valueFrom:
            secretKeyRef:
              name: sftp-secrets
              key: username
        - name: SFTP_PASSWORD
          valueFrom:
            secretKeyRef:
              name: sftp-secrets
              key: password
        - name: SFTP_SERVER
          valueFrom:
            secretKeyRef:
              name: sftp-secrets
              key: server
        - name: SFTP_REMOTE_DIR
          valueFrom:
            secretKeyRef:
              name: sftp-secrets
              key: remote_directory
        - name: MOUNT_POINT
          value: "/mnt/sftp"
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80
        volumeMounts:
        - name: sftp-mount
          mountPath: /usr/share/nginx/html/images
      volumes:
      - name: sftp-mount
        emptyDir: {}
```