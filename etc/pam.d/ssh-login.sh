#!/bin/sh

# Important !!!
# Copy to:
# /etc/pam.d/
# Set permissions:
# chmod +x /etc/pam.d/vps-ssh-login.sh

# Variables
EMAIL=admin_email@gmail.com
FROM_EMAIL=root@your.domain

SUBJECT="Alert! Vps login!"
MESSAGE="
A user signed into your server through SSH.
-------------------------------------------
Username: ${PAM_USER}
IP Address: ${PAM_RHOST}
Date: `date`"

# Send email
if [ ${PAM_TYPE} = "open_session" ]; then
        echo "${MESSAGE}" | mailx -a "From: Admin Root <${FROM_EMAIL}>" -s "${SUBJECT}" "${EMAIL}"
fi

exit 0
