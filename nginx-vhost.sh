#!/bin/bash

# Variables

# Domain host
DOMAIN="example.com"
# SSL certs
SSL_CERT="/etc/ssl/certs/ssl-cert-snakeoil.pem"
SSL_KEY="/etc/ssl/private/ssl-cert-snakeoil.key"
# Redirect to page with www.
SSL_WITH_WWW=false
# File max upload size
MAX_UPLOAD_MB=100
# Allow edit /var/www to user
WWW_USER="debain"

# Don't change below

# Redirect to host with www or without www
if [ "${SSL_WITH_WWW}" = "true" ]; then
  FROM_HOST="${DOMAIN}"
  TO_HOST="www.${DOMAIN}"
else
  FROM_HOST="www.${DOMAIN}"
  TO_HOST="${DOMAIN}"
fi

# Create http
echo "
# Http server
server {
  listen 80;
  listen [::]:80;
  server_name ${DOMAIN} www.${DOMAIN};
  # Letsencrypt certbot webroot
  root /var/www/${DOMAIN}/public;  
  location ^~ /.well-known/acme-challenge/ {
    default_type "text/plain";
  }
  location = /.well-known/acme-challenge/ {
    return 404;
  }
  # Redirect ssl
  return 301 https://${TO_HOST}\$request_uri;
}
" > "/etc/nginx/sites-enabled/${DOMAIN}.conf"

# Create https
echo "
# Ssl server
server {
  listen 443 ssl http2;
  listen [::]:443 ssl http2;
  server_name ${FROM_HOST};
  ssl_certificate ${SSL_CERT};
  ssl_certificate_key ${SSL_KEY};
  ssl_protocols TLSv1.2 TLSv1.3;
  ssl_ciphers HIGH:!aNULL:!MD5;
  return 301 https://${TO_HOST}\$request_uri;
}

# Ssl server
server {
  listen 443 ssl http2;
  listen [::]:443 ssl http2;
  server_name ${TO_HOST};
  root /var/www/${DOMAIN}/public;
  index index.php index.html;
  access_log /var/log/nginx/${DOMAIN}.ssl.log;
  error_log /var/log/nginx/${DOMAIN}.ssl.log error;
  ssl_certificate ${SSL_CERT};
  ssl_certificate_key ${SSL_KEY};
  ssl_protocols TLSv1.2 TLSv1.3;
  ssl_ciphers HIGH:!aNULL:!MD5;
  ssl_prefer_server_ciphers on;
  add_header Strict-Transport-Security 'max-age=44768000; includeSubdomains; preload;';
  add_header X-Frame-Options DENY;
  add_header X-Content-Type-Options nosniff;
  location / {
    # try_files \$uri \$uri/ =404;
    try_files \$uri \$uri/ /index.php\$is_args\$args;
  }
  location ~ \.php\$ {
    include snippets/fastcgi-php.conf;
    fastcgi_pass unix:/run/php/php8.1-fpm.sock;
    # fastcgi_pass 127.0.0.1:9000;
  }
  location /storage {
    location ~ \.php\$ {return 403;}
  }
  location = /favicon.ico {
    rewrite . /favicon/favicon.ico;
  }
  location ~ /(cache|secret|.git|vendor) {
    deny all;
    return 404;
  }
  location ~* \.(html|js|ts|css|png|jpg|jpeg|gif|webp|svg|ico|flv|pdf|mp3|mp4|mov|xml)\$ {
    add_header Cache-Control 'public, no-transform';
    add_header 'Set-Cookie' '';
    fastcgi_hide_header 'Set-Cookie';
    fastcgi_hide_header 'Cookie';
    log_not_found off;
    access_log off;
    expires -1;
  }
  keepalive_timeout 70;
  disable_symlinks off;
  client_max_body_size ${MAX_UPLOAD_MB}M;
  charset utf-8;
  source_charset utf-8;
  server_tokens off;
}
" > "/etc/nginx/sites-enabled/${DOMAIN}.ssl.conf"

# New dir
sudo mkdir -p "/var/www/${DOMAIN}/public"
sudo mkdir -p "/var/www/${DOMAIN}/public/.well-known/acme-challenge"

# Add index page
echo "Html Works ..." > "/var/www/${DOMAIN}/public/index.html"
echo "<?php echo 'Php Works ...';" > "/var/www/${DOMAIN}/public/index.php"

# Chmods
sudo chown -R www-data:www-data /etc/nginx/sites-enabled
sudo chmod -R 2775 /etc/nginx/sites-enabled

# Debian user chmods
sudo chown -R "${WWW_USER}:www-data" /var/www
sudo chmod -R 2775 /var/www

# Restart
sudo service nginx restart
