#!/bin/bash

# Variables
VPSUSER=debian

# Remove user from sudo
sudo gpasswd -d $VPSUSER sudo

# Remove sudo users
echo "" > /etc/sudoers.d/90-cloud-init-users
echo "# User rules for debian" >> /etc/sudoers.d/90-cloud-init-users
echo "# debian ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/90-cloud-init-users

# Show
sudo cat /etc/sudoers.d/90-cloud-init-users
