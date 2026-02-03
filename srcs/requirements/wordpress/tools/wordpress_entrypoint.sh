#!/bin/sh
set -e

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
chmod 755 /run/mysqld

mkdir -p /var/lib/mysql
chown -R mysql:mysql /var/lib/mysql
chmod 755 /var/lib/mysql

if [ ! -d /var/lib/mysql/mysql ]; then
	if [ -z "$DB_NAME" ] || [ -z "$DB_USER" ] || [ -z "$DB_USERPASS" ] || [ -z "$DB_ROOTPASS" ]; then
		echo "Missing value(s) of variable(s), exiting"
		exit 1
	fi
	echo "Initializing /var/lib/mysql - first time"
	mariadb-install-db --user=mysql --datadir=/var/lib/mysql --socket=/run/mysqld/mysqld.sock

	mariadbd --user=mysql --skip-networking --socket=/run/mysqld/mysqld.sock --datadir=/var/lib/mysql & # maybe: --socket=/run/mysqld/mysqld.sock --datadir=/var/lib/mysql
	tmp_pid=$!

	while ! mariadb-admin ping --socket=/run/mysqld/mysqld.sock >/dev/null 2>&1 ; do # > /dev/null 2>&1 to discard possible stdout/err messages
		echo "Waiting for temporary mariadbd..."
		sleep 1
	done

	mariadb --socket=/run/mysqld/mysqld.sock <<-EOSQL
		CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;
		ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOTPASS}';
		CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_USERPASS}';
		GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
	EOSQL

	kill "$tmp_pid"
	wait "$tmp_pid"
	echo "temp daemon ended with: $?"
fi

exec 