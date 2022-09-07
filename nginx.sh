#!/bin/bash

# Reinstall server
sudo apt remove -y --purge nginx
sudo apt autoremove -y

# Install
sudo apt install -y nginx

# Restart
sudo service nginx restart
