#!/bin/bash

echo "[INFO] Installing Memcached on CentOS..."

# ---------------------------
# 1. Install Memcached
# ---------------------------
sudo dnf install -y memcached

# ---------------------------
# 2. Start & enable Memcached
# ---------------------------
sudo systemctl enable memcached
sudo systemctl start memcached

# ---------------------------
# 3. Configure firewalld
# ---------------------------
sudo systemctl start firewalld
sudo systemctl enable firewalld

# Allow Memcached port (11211)
sudo firewall-cmd --permanent --add-port=11211/tcp
sudo firewall-cmd --reload

# ---------------------------
# 4. Optional: Edit Memcached config (bind to hostname)
# ---------------------------
# If you want Memcached to listen on mc01, uncomment below:
# sudo sed -i 's/OPTIONS=.*/OPTIONS="-l mc01 -p 11211 -u memcached"/' /etc/sysconfig/memcached
# sudo systemctl restart memcached

echo "----------------------------------------------"
echo " Memcached installation completed!"
echo " Host: mc01"
echo " Port: 11211"
echo " Service: active and enabled"
echo " Firewall: port 11211/tcp open"
echo "----------------------------------------------"
