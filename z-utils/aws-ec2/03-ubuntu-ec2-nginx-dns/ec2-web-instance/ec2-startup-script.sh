#!/usr/bin/env bash
exec > >(tee /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1
echo BEGIN
sudo apt update -y
sudo apt install nginx -y
sudo ufw allow 'Nginx Full'
sudo ufw enable
sudo ufw allow 22/tcp
sudo ufw status numbered
echo END
