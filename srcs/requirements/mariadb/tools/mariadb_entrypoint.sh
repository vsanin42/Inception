#!/bin/sh
set -e

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
chmod 755 /run/mysqld

mkdir -p /var/lib/mysql
chown -R mysql:mysql /var/lib/mysql
chmod 755 /var/lib/mysql

if [ ! -d /var/lib/mysql/mysql ]; then
    echo "Initializing /var/lib/mysql - first time"
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
fi

exec mariadbd --user=mysql