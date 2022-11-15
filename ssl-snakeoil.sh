#!/bin/bash

# Snakeoil cert
sudo apt install ssl-cert

# Update snakeoil host name
sudo make-ssl-cert generate-default-snakeoil --force-overwrite
