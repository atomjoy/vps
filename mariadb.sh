#!/bin/bash

# Variables

# Db root pass
PASS=toor
# Disable root pass
REMOVE_PASS=false
# Db laravel pass
PASS_LARAVEL=toor
# Disable laravel pass
REMOVE_PASS_LARAVEL=false
# Restore database /path/to/db.sql
DB_RESTORE_PATH=""

# Don't touch below

# Backup, remove old db
sudo tar -czf /var/backups/mysql-$(date +%Y%m%d-%s).tar.gz /var/lib/mysql

# Reinstall server
sudo apt remove -y --purge mariadb-server
sudo apt autoremove -y

# Remove databases
sudo rm -rf /var/lib/mysql

# Install
sudo apt install -y mariadb-server

mysql -u root -e "
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
"

# Not empty
if [ -z "$PASS" ]; then
  echo "Add root password!"
fi

# Not empty
if [ -z "$PASS_LARAVEL" ]; then
  echo "Add laravel password!"
fi

# Laravel
if [ "$PASS_LARAVEL" ]; then
mysql -u root -e "
CREATE DATABASE laravel CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE laravel_testing CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
GRANT ALL ON laravel.* TO 'laravel'@'localhost' IDENTIFIED BY '${PASS_LARAVEL}' WITH GRANT OPTION;
GRANT ALL ON laravel.* TO 'laravel'@'127.0.0.1' IDENTIFIED BY '${PASS_LARAVEL}' WITH GRANT OPTION;
GRANT ALL ON laravel_testing.* TO 'laravel'@'localhost' IDENTIFIED BY '${PASS_LARAVEL}' WITH GRANT OPTION;
GRANT ALL ON laravel_testing.* TO 'laravel'@'127.0.0.1' IDENTIFIED BY '${PASS_LARAVEL}' WITH GRANT OPTION;
FLUSH PRIVILEGES;
"
fi

# Root pass
if [ "$PASS" ]; then
mysql -u root -e "
GRANT ALL ON *.* TO 'root'@'localhost' IDENTIFIED BY '${PASS}' WITH GRANT OPTION;
GRANT ALL ON *.* TO 'root'@'127.0.0.1' IDENTIFIED BY '${PASS}' WITH GRANT OPTION;
FLUSH PRIVILEGES;
"
fi

# Remove laravel user pass
if [ "${REMOVE_PASS_LARAVEL}" = "true" ]; then
mysql -u root -p$PASS -e "
SET PASSWORD FOR 'laravel'@'localhost' = '';
SET PASSWORD FOR 'laravel'@'127.0.0.1' = '';
FLUSH PRIVILEGES;
"
fi

# Remove root user pass
if [ "${REMOVE_PASS}" = "true" ]; then
mysql -u root -p$PASS -e "
SET PASSWORD FOR 'root'@'localhost' = '';
SET PASSWORD FOR 'root'@'127.0.0.1' = '';
FLUSH PRIVILEGES;
"
fi

# Restore database
if [ "$DB_RESTORE_PATH" ]; then
  if [ -f "$DB_RESTORE_PATH" ]; then
    SECRET="-p${PASS}"
    if [ "${REMOVE_PASS}" = "true" ]; then
      SECRET=""
    fi
    mysql -u root $SECRET -e "SET GLOBAL FOREIGN_KEY_CHECKS=0;"
    mysql -u root $SECRET < $DB_RESTORE_PATH
    mysql -u root $SECRET -e "SET GLOBAL FOREIGN_KEY_CHECKS=1;"
  else
    echo "Sql file does not exists!"
  fi
fi

### db_root_password=toor
### mysql -u root -e "UPDATE mysql.user SET Password=PASSWORD('toor') WHERE User='root';"
### mysql -u root -e "SET PASSWORD FOR root@localhost = PASSWORD('toor');"
### mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '';"
### mysql -u root -e "FLUSH PRIVILEGES;"
