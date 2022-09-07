#!/bin/bash

# Variables
USER=debian

# Add user to sudo group
sudo usermod -a -G sudo $USER

# Add sudo user
echo "# Rules for ${USER}" > /etc/sudoers.d/90-user-$USER
echo "${USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/90-user-$USER

# Show
sudo cat /etc/sudoers.d/90-user-$USER
