#!/bin/bash

### UFW firewall

# Variables

# Ssh port
SSH_PORT=22
# Allow only from ip range (1.0.0.0/8, 1.2.0.0/16, 1.2.3.0/24)
SSH_IP_MASK="1.2.0.0/16"
# Allow from all ip's
ALLOW_SSH=true
# Open http, https
ALLOW_HTTP=false
# Allow smtp
ALLOW_SMTP=false

# Don't change below

# Install ufw
sudo apt install -y ufw

# Ufw now
sudo ufw --force disable

# Ufw clear
sudo ufw --force reset

# Ssh ip/s range
sudo ufw allow proto tcp from $SSH_IP_MASK to 0.0.0.0/0 port $SSH_PORT

# Ssh all ip's
if [ "$ALLOW_SSH" = "true" ]; then
  sudo ufw allow proto tcp to 0.0.0.0/0 port $SSH_PORT
fi

# Www
if [ "$ALLOW_HTTP" = "true" ]; then
  sudo ufw allow 80/tcp
  sudo ufw allow 443/tcp
fi

# Smtp
if [ "$ALLOW_SMTP" = "true" ]; then
  sudo ufw allow proto tcp to 0.0.0.0/0 port 25
fi

# Policy
sudo ufw default allow outgoing
sudo ufw default deny incoming

# Logs
sudo ufw logging on

# Run on boot
sudo ufw --force enable

# Show rules
sudo ufw status numbered

# Ufw show
echo " "
echo "Show ufw rules:"
echo "sudo ufw status numbered"

# Ufw delete
echo " "
echo "Then delete rule with:"
echo "sudo ufw delete {rule_number}"
