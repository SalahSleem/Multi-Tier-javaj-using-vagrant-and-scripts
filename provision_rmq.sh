#!/bin/bash

# ---------------------------
# Variables
# ---------------------------
DB_USER="admin"
DB_PASS="admin123"

# ---------------------------
# 1. Enable repositories and import GPG key
# ---------------------------
echo "Enabling required repositories..."

sudo dnf install -y epel-release

# Add Erlang & RabbitMQ repos from Cloudsmith
sudo dnf install -y \
  https://dl.cloudsmith.io/public/rabbitmq/rabbitmq-erlang/rpm/el/9/x86_64/rabbitmq-erlang-repo-1.0-1.el9.noarch.rpm \
  https://dl.cloudsmith.io/public/rabbitmq/rabbitmq-server/rpm/el/9/x86_64/rabbitmq-server-repo-1.0-1.el9.noarch.rpm

# Import official RabbitMQ GPG key
sudo rpm --import https://packagecloud.io/rabbitmq/rabbitmq-server/gpgkey

sudo tee /etc/yum.repos.d/rabbitmq.repo <<EOF
[rabbitmq-server]
name=RabbitMQ Repository
baseurl=https://packagecloud.io/rabbitmq/rabbitmq-server/el/9/\$basearch
repo_gpgcheck=0
gpgcheck=0
enabled=1
EOF


# ---------------------------
# 2. Install Erlang and RabbitMQ
# ---------------------------
echo "Installing Erlang and RabbitMQ..."
sudo dnf install -y erlang
sudo dnf install -y rabbitmq-server

# ---------------------------
# 3. Enable and start RabbitMQ service
# ---------------------------
echo "Enabling and starting RabbitMQ..."
sudo systemctl enable --now rabbitmq-server
sudo systemctl status rabbitmq-server --no-pager

# ---------------------------
# 4. Enable Management Plugin
# ---------------------------
echo "Enabling RabbitMQ Management Plugin..."
sudo rabbitmq-plugins enable rabbitmq_management

# ---------------------------
# 5. Add admin user
# ---------------------------
echo "Creating admin user '$DB_USER'..."
sudo rabbitmqctl add_user $DB_USER $DB_PASS
sudo rabbitmqctl set_user_tags $DB_USER administrator
sudo rabbitmqctl set_permissions -p / $DB_USER ".*" ".*" ".*"

# ---------------------------
# 6. Configure firewall
# ---------------------------
echo "Starting and enabling firewalld..."
sudo systemctl enable --now firewalld

echo "Opening RabbitMQ ports 5672 (AMQP) and 15672 (Management UI)..."
sudo firewall-cmd --permanent --add-port=5672/tcp
sudo firewall-cmd --permanent --add-port=15672/tcp
sudo firewall-cmd --reload

# ---------------------------
# 7. Completion message
# ---------------------------
echo "----------------------------------"
echo " RabbitMQ installation completed!"
echo " Access Management UI at: http://<server-ip>:15672"
echo " Username: $DB_USER"
echo " Password: $DB_PASS"
echo "----------------------------------"
