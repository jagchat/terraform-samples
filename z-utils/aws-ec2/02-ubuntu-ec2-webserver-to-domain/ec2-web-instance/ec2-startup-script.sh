#!/usr/bin/env bash
exec > >(tee /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1
echo BEGIN
sudo apt update
sudo apt install -y apache2
sudo ufw allow 'Apache Full'
sudo ufw enable
sudo ufw allow 22/tcp
echo END
