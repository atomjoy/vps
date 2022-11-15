#!/bin/bash

# Openssl
sudo apt install openssl ca-certificates

# Self signed
sudo mkdir -p /etc/ssl/localcerts
sudo openssl req -new -x509 -days 3650 -nodes -out /etc/ssl/localcerts/vps.pem -keyout /etc/ssl/localcerts/vps.key
sudo chmod 600 /etc/ssl/localcerts/vps*
