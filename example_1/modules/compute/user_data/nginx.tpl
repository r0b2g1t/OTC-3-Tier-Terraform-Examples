#! /bin/bash

ufw disable

# Install Nginx
apt update
apt install -y nginx

# Configure Nginx
rm /etc/nginx/sites-available/default
rm /etc/nginx/sites-enabled/default

cat > /etc/nginx/sites-available/tomcat << "EOF"
server {
    listen 80;
    listen [::]:80;
    server_name  _;

    proxy_redirect           off;
    proxy_set_header         X-Real-IP $remote_addr;
    proxy_set_header         X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header         Host $http_host;

    location / {
            proxy_pass http://${middleware_ip}:8080;
        }
}
server {
    listen 443;
    listen [::]:443;
    server_name  _;

    proxy_redirect           off;
    proxy_set_header         X-Real-IP $remote_addr;
    proxy_set_header         X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header         Host $http_host;

    location / {
            proxy_pass http://${middleware_ip}:8443;
        }
}
EOF

ln -s /etc/nginx/sites-available/tomcat /etc/nginx/sites-enabled/
systemctl restart nginx.service