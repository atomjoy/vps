#!/bin/bash

# Variables (change vars here)

# Vps host: vps
VPS_HOST=hello

# Vps hostname
VPS_FQDN_HOST=hello.example.com

# Hostname
sudo hostname ${VPS_FQDN_HOST}

# Hosts
echo "" > /etc/hosts
echo "127.0.0.1 ${VPS_HOST} ${VPS_FQDN_HOST} localhost" >> /etc/hosts
echo "::1     localhost ip6-localhost ip6-loopback" >> /etc/hosts
echo "ff02::1 ip6-allnodes" >> /etc/hosts
echo "ff02::2 ip6-allrouters" >> /etc/hosts
