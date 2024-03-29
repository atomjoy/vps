#!/bin/bash

# Zmiana hostname, instalacja firewall, file2ban i postfixa do wysyłania wiadomości email.

HOST="hello"
DOMAIN="example.com"
TESTMAIL="email@example.com"
IP="127.0.0.1"
SSH_PORT=22
# Allow only from ip range (1.0.0.0/8, 1.2.0.0/16, 1.2.3.0/24)
# SSH_IP_MASK="1.2.0.0/16"

echo "Config"
FQHOST="${HOST}.${DOMAIN}"
MAILNAME="${DOMAIN}"

echo "Hostname"
cp /etc/hosts /etc/hosts_copy
sed -i "/${IP} ${FQHOST} ${HOST}/d" /etc/hosts
echo "${IP} ${FQHOST} ${HOST}" >> /etc/hosts
echo "${MAILNAME}" > /etc/mailname
sudo hostnamectl set-hostname $HOST
sudo hostname
sudo hostname -f

echo "Install certs"
sudo apt install openssl ca-certificates ssl-cert ufw -y
sudo make-ssl-cert generate-default-snakeoil --force-overwrite
sudo apt install net-tools dnsutils mailutils -y

echo "Remove smtp"
sudo apt -y --purge remove exim4-*
sudo apt -y --purge remove postfix

echo "Update install"
sudo apt update -y
sudo apt upgrade -y

echo "Postfix"
echo "root: root" >> /etc/aliases
echo "postfix postfix/mailname string ${MAILNAME}" | debconf-set-selections
echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections
sudo apt install -y postfix
sed -i '/inet_interfaces/d' /etc/postfix/main.cf
sed -i '/inet_protocols/d' /etc/postfix/main.cf
echo "inet_interfaces = loopback-only" >> /etc/postfix/main.cf
echo "inet_protocols = ipv4" >> /etc/postfix/main.cf
sudo systemctl restart postfix

echo "Send email"
echo "Sample email `date`" | mail -s "Welcome, vps test `date`" $TESTMAIL
echo "Smtp test message `date`" | mailx -s "Welcome message `date`" -a "From: Admin Root <root@${MAILNAME}>" $TESTMAIL

echo "Ufw"
sudo ufw --force disable
sudo ufw --force reset
# Rules
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
# Policy
sudo ufw logging on
sudo ufw default allow outgoing
sudo ufw default deny incoming
# Rules ssh
# sudo ufw allow proto tcp from $SSH_IP_MASK to 0.0.0.0/0 port $SSH_PORT
sudo ufw allow proto tcp to 0.0.0.0/0 port $SSH_PORT
# Enable
sudo ufw --force enable
sudo ufw status numbered

# Fail2ban conf
sudo apt install fail2ban -y
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
echo "
[sshd]
enabled = true
port = ssh
action = iptables-multiport
logpath = /var/log/secure
maxretry = 3
bantime = 600
" > /etc/fail2ban/jail.d/defaults-debian.conf
sudo service fail2ban restart

echo "Clean"
sudo apt autoremove -y
