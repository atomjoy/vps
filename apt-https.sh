#!/bin/bash

### APT https

# Backup file
sudo cp /etc/apt/sources.list "/var/backups/etc_apt_sources.list.backup-$(date +%s)"

# Install
sudo apt install -y apt-transport-https

# Secure apt
sudo sed -i 's/http\:/https\:/g' /etc/apt/sources.list

# Update sources
sudo apt update -y

# Upgrade list
sudo apt list --upgradable

# Upgrade
sudo apt -y upgrade
