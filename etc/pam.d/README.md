# Powiadomienie email o logowaniu do ssh
Zmień koniecznie odbiorce i nadawcę wiadomości w pliku: **ssh-login.sh** i ustaw **UsePam** na **yes** w **/etc/ssh/sshd_config**.

## Zainstaluj wcześniej
```sh
sudo apt install mailutils postfix -y
```

### Dodaj do katalogu
```sh
/etc/pam.d/ssh-login.sh
```

### Pozwól na wykonanie pliku
```sh
chmod 0700 /etc/pam.d/ssh-login.sh
chown root:root /etc/pam.d/ssh-login.sh
chmod +x /etc/pam.d/ssh-login.sh
```

### Dodaj na końcu pliku /etc/pam.d/sshd
```sh
# Ssh login email
session required pam_exec.so /etc/pam.d/ssh-login.sh
```

## Do poczytania
```sh
https://geekthis.net/post/run-scripts-after-ssh-authentication
https://geekthis.net/post/email-alert-ssh-login
```
