# Konfiguracja serwera VPS z sytemem Debian 11
Konfiguracja serwera VPS Debian 11 z ovh (LEMP, Letsencrypt certbot, logowanie z kluczami ssh, serwer smtp do wysyłania wiadomości email, ufw firewall).

## Uruchom jako root
```sh
# Utwórz hasło root
sudo passwd root

# Zaloguj jako root
su

# Zmień hasło użytkownika debian (opcjonalnie)
sudo passwd debian
```

## Klucze ssh
```sh
# Utwórz klucz rsa ~/.ssh/id_rsa
ssh-keygen -t rsa -C "your_email@example.com"
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"

# Utwórz klucz Ed25519 (można użyć do logowania na githuba np.)
ssh-keygen -t ed25519 -C "your_email@example.com"

# Wyślij na serwer
ssh-copy-id -i ~/.ssh/id_rsa.pub $vps_user@$vps_host_or_ip
```

## Ustawienia serwera ssh
Logowanie tylko z kluczami ssh, bez hasła i logowania na root.
```sh
# Ustaw wcześniej klucze ssh dla zalogowanego użytkownika !!!
sudo bash ssh.sh
```

## Uruchom skrypty
Nie zapomij zmienić ustawienia w każdym skrypcie (variables) !!!

1. sudo bash apt-https.sh
2. sudo bash ufw.sh
3. sudo bash php.sh
4. sudo bash nginx.sh
5. sudo bash certbot.sh
6. sudo bash nginx-vhost.sh
7. sudo bash postfix.sh
8. sudo bash mariadb.sh
9. sudo bash remove-sudo-user.sh

## Usuwanie użytkownika debian z sudo
```bash
sudo bash remove-sudo-user.sh
```

## Połączenia i certyfikaty
```sh
# Aktualizacja certyfikatu snakeoil
sudo make-ssl-cert generate-default-snakeoil --force-overwrite

# Podgląd certyfikatu ssl
openssl x509 -noout -subject -in /etc/ssl/certs/ssl-cert-snakeoil.pem

# Połącz z serwerem smtp :25 :578
openssl s_client -starttls smtp -crlf -connect 127.0.0.1:25

# Połącz z serwerem smtp
telnet localhost 25

# Test http/https
 wget --no-check-certificate https://example.com
```

## Wyślij email z cmd
```sh
sudo apt install mailutils postfix

# Linux mail
echo "Test email `date`" | mail -s "Welcome today is `date`" your_email@gmail.com

# Linux mailx
echo "From test `date`" | mailx -s "From address test" -a 'From: Admin Root <root@example.com>' your_email@gmail.com
```
