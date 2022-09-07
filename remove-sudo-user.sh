#!/bin/bash

# Variables
USER=username

# Remove user from sudo
sudo gpasswd -d $USER sudo

# Remove sudo users
echo "" > /etc/sudoers.d/90-user-$USER
echo "# User rules for ${USER}" >> /etc/sudoers.d/90-user-$USER
echo "# ${USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/90-user-$USER

# Show
sudo cat /etc/sudoers.d/90-user-$USER
