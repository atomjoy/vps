#!/bin/bash

#################################
####  Send only smtp script  ####
####  sudo bash ./postfix.sh ####
#################################

# Dns zone
# Record A hello.example.com. 1.2.3.4
# Record SPF example.com. spf1="a mx ptr ipv4:1.2.3.4 include:mx.ovh.com -all"
# File
# OFILE=/var/my-backup-$(date +%Y%m%d).tgz

# Variables (change vars here)

# Send email from: domain.name
MAILNAME=example.com
# Vps dns fqdn host for A record: vps.domain.name
VPS_HOST_FQDN=hello.example.com
# Vps hostname: vps
VPS_HOST=hello
# Sent test email to
TESTMAIL=your_email_here@gmail.com

# Don't touch below
sudo apt -y --purge remove exim4-*
sudo apt -y --purge remove postfix

# Update
sudo apt update -y

# Install utils
sudo apt install -y net-tools dnsutils mailutils

# Install postfix
echo "postfix postfix/mailname string ${MAILNAME}" | debconf-set-selections
echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections
sudo apt install -y postfix

# Hosts
echo "" > /etc/hosts
echo "127.0.0.1 ${MAILNAME} ${VPS_HOST} localhost" >> /etc/hosts
echo "::1     localhost ip6-localhost ip6-loopback" >> /etc/hosts
echo "ff02::1 ip6-allnodes" >> /etc/hosts
echo "ff02::2 ip6-allrouters" >> /etc/hosts

# Hostname, create snakoil cert
sudo hostname $VPS_HOST_FQDN
sudo make-ssl-cert generate-default-snakeoil --force-overwrite

# Smtp
sudo hostname $VPS_HOST
echo $VPS_HOST > /etc/hostname
echo $MAILNAME > /etc/mailname

# Show full hostname
echo "Vps fqdn host"
sudo hostname -f

# Setup
sudo cp /etc/postfix/main.cf "/etc/postfix/main.cf.backup-$(date +%s)"
# Aliases
echo "root: root" >> /etc/aliases
# Postfix
echo "" > /etc/postfix/main.cf
echo "myhostname = ${VPS_HOST_FQDN}" >> /etc/postfix/main.cf
echo "myorigin = ${MAILNAME}" >> /etc/postfix/main.cf
echo "mydestination = ${MAILNAME}, ${VPS_HOST_FQDN}, localhost" >> /etc/postfix/main.cf
echo "smtpd_banner = \$myhostname ESMTP \$mail_name" >> /etc/postfix/main.cf
echo "biff = no" >> /etc/postfix/main.cf
echo "append_dot_mydomain = no" >> /etc/postfix/main.cf
echo "readme_directory = no" >> /etc/postfix/main.cf
echo "compatibility_level = 2" >> /etc/postfix/main.cf
echo "smtpd_tls_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem" >> /etc/postfix/main.cf
echo "smtpd_tls_key_file=/etc/ssl/private/ssl-cert-snakeoil.key" >> /etc/postfix/main.cf
echo "smtpd_tls_security_level=may" >> /etc/postfix/main.cf
echo "smtp_tls_CApath=/etc/ssl/certs" >> /etc/postfix/main.cf
echo "smtp_tls_security_level=may" >> /etc/postfix/main.cf
echo "smtp_tls_session_cache_database = btree:\${data_directory}/smtp_scache" >> /etc/postfix/main.cf
echo "smtpd_relay_restrictions = permit_mynetworks permit_sasl_authenticated defer_unauth_destination" >> /etc/postfix/main.cf
echo "alias_maps = hash:/etc/aliases" >> /etc/postfix/main.cf
echo "alias_database = hash:/etc/aliases" >> /etc/postfix/main.cf
echo "relayhost =" >> /etc/postfix/main.cf
echo "relay_domain =" >> /etc/postfix/main.cf
echo "mynetworks = 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128" >> /etc/postfix/main.cf
echo "mailbox_size_limit = 0" >> /etc/postfix/main.cf
echo "recipient_delimiter = +" >> /etc/postfix/main.cf
# Only localhost [all|loopback-only]
echo "inet_interfaces = loopback-only" >> /etc/postfix/main.cf
# Only [all|ip4]
echo "inet_protocols = ipv4" >> /etc/postfix/main.cf

# Restart
sudo service postfix restart

# Mail
echo "Sample email `date`" | mail -s "Welcome, vps test `date`" $TESTMAIL

# Show log
echo "Show logs for more"
echo "sudo cat /var/log/mail.log"
