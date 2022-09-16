# Nginx certyfikaty ssl letsencrypt i certbot

### Tworzenie certyfikatu ssl bez serwera http
```sh
sudo service nginx stop
sudo certbot certonly --standalone --noninteractive --agree-tos --preferred-challenges=http --email your_email@example.com --expand -d example.com -d www.example.com
sudo service nginx start
```

### Tworzenie certyfikatu ssl z uruchomionym serwerem http
```sh
sudo certbot certonly --noninteractive --agree-tos --preferred-challenges=http --email your_email@example.com --expand --webroot --webroot-path /var/www/example.com -d example.com -d www.example.com
sudo service nginx restart
```

### Certyfikat dla domeny
```sh
# Certyfikat
/etc/letsencrypt/live/example.com/fullchain.pem 
# Klucz 
/etc/letsencrypt/live/example.com//privkey.pem
```

### Dezaktywacja i usuwanie certyfikatu ssl
```sh
sudo certbot revoke --noninteractive --cert-path /etc/letsencrypt/live/example.com/fullchain.pem
sudo certbot delete --noninteractive --cert-name example.com
```


### Generator ssl vhost
```sh
https://ssl-config.mozilla.org
```
