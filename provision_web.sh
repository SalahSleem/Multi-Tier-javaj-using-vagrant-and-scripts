#!/bin/bash

# ============================================================
# Install NGINX & configure reverse proxy to Tomcat server
# ============================================================

# Update system
# sudo apt-get update -y

# Install NGINX
sudo apt-get install -y nginx

# Allow HTTP & HTTPS through firewall
sudo ufw allow 80
sudo ufw allow 443
sudo ufw --force enable

# Remove default site to avoid conflicts
sudo rm -f /etc/nginx/sites-enabled/default

# Create reverse proxy configuration
sudo tee /etc/nginx/sites-available/tomcat_proxy > /dev/null <<EOF
server {
    listen 80;
    server_name _;

    # Forward ALL traffic to Tomcat server
    location / {
        proxy_pass http://192.168.56.11:8080/;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

# Enable the proxy config
sudo ln -sf /etc/nginx/sites-available/tomcat_proxy /etc/nginx/sites-enabled/tomcat_proxy

# Test NGINX config
sudo nginx -t

# Restart NGINX
sudo systemctl restart nginx
sudo systemctl enable nginx

echo "NGINX reverse proxy setup complete. All traffic forwarded to Tomcat."
