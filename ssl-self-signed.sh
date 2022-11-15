#!/bin/bash

# Snakeoil cert
sudo apt install ssl-cert

# Openssl
sudo apt install openssl ca-certificates

# Self signed
sudo mkdir -p /etc/ssl/localcerts
sudo openssl req -new -x509 -days 3650 -nodes -out /etc/ssl/localcerts/nginx.pem -keyout /etc/ssl/localcerts/nginx.key
sudo chmod 600 /etc/ssl/localcerts/nginx*
