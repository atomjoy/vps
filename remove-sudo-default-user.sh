#!/bin/bash

# Variables
VPSUSER=debian

# Remove vps default user from sudo
sudo gpasswd -d $VPSUSER sudo

# Remove sudo users
echo "" > /etc/sudoers.d/90-cloud-init-users
echo "# User rules for ${VPSUSER}" >> /etc/sudoers.d/90-cloud-init-users
echo "# ${VPSUSER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/90-cloud-init-users

# Show
sudo cat /etc/sudoers.d/90-cloud-init-users
