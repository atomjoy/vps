#!/bin/bash

# !!! Run after setting ssh keys on server !!!
# The script disables password login and root login only allows auth with ssh keys.

# Backup
sudo cp /etc/ssh/sshd_config /var/backups/etc_ssh_sshd_config-backup-$(date +%s)

# Clear all
echo "Include /etc/ssh/sshd_config.d/*.conf" > /etc/ssh/sshd_config

# Create
echo "
# Port
Port 22

# Only ipv4
ListenAddress 0.0.0.0

# Ssh keys
PubkeyAuthentication yes

# Disable root login
PermitRootLogin no

# Allow user check
UsePAM yes
# Disable password login
PasswordAuthentication no
ChallengeResponseAuthentication no
ChallengeResponseAuthentication no
KerberosAuthentication no
GSSAPIAuthentication no

# Disable rest
AllowAgentForwarding no
AllowTcpForwarding no
X11Forwarding no
GatewayPorts no
PermitTunnel no
PrintMotd no
UseDNS no

# Allow sftp client
Subsystem sftp  /usr/lib/openssh/sftp-server
" > /etc/ssh/sshd_config.d/debian.conf

# Restart
sudo service sshd restart
sudo service ssh restart
