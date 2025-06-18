#!/bin/bash

set -a
source .env
set +a

echo "Setting DNS"
sudo apt install bind9 bind9utils bind9-doc dnsutils -y
envsubst '$DNS_NAME $DNS_MAIL $DNS_IP'  < DNS/named.conf.template > /etc/bind/named.conf.local
envsubst '$DNS_NAME $DNS_MAIL $DNS_IP'  < DNS/db.template > /etc/bind/db.$DNS_NAME
sudo systemctl restart bind9
echo "Finished setting DNS"

echo "Setting Nginx Reverse Proxy"
sudo apt install nginx -y
sudo rm /etc/nginx/sites-available/default
sudo rm /etc/nginx/sites-enabled/default
envsubst '$DNS_NAME $SSL_CERTIFICATE $SSL_CERTIFICATE_KEY $PROXY_PASS' < Reverse_Proxy/Reverse_Proxy.conf.template > /etc/nginx/sites-available/Reverse_Proxy.conf
sudo ln -s /etc/nginx/sites-available/Reverse_Proxy.conf /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
echo "Finished setting Nginx"

echo "Setting monitoring email alert"
sudo mkdir -p /etc/ssmtp
sudo apt install ssmtp -y
envsubst < Monitoring/ssmtp.conf.template > /etc/ssmtp/ssmtp.conf
echo "Finished setting monitoring email alert"


