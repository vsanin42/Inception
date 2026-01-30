#!/bin/sh
set -e

# create directory where mysqld socket is placed
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
chmod 755 /run/mysqld

# create and set perms for datadir used at initialization if doesn't exist
mkdir -p /var/lib/mysql
chown -R mysql:mysql /var/lib/mysql
chmod 755 /var/lib/mysql

# check if it's the first run - initialize everything
if [ ! -d /var/lib/mysql/mysql ]; then
	# check if .env file has necessary values
	if [ -z "$DB_NAME" ] || [ -z "$DB_USER" ] || [ -z "$DB_USERPASS" ] || [ -z "$DB_ROOTPASS" ]; then
		echo "Missing value(s) of variable(s), exiting"
		exit 1
	fi
	echo "Initializing /var/lib/mysql - first time"
	mariadb-install-db --user=mysql --datadir=/var/lib/mysql --socket=/run/mysqld/mysqld.sock

	# start a temporary daemon in background that will not take pid 1 to set up db in advance, save its pid
	mariadbd --user=mysql --skip-networking --socket=/run/mysqld/mysqld.sock --datadir=/var/lib/mysql & # maybe: --socket=/run/mysqld/mysqld.sock --datadir=/var/lib/mysql
	tmp_pid=$!

	# wait for it to go live
	while ! mariadb-admin ping --socket=/run/mysqld/mysqld.sock >/dev/null 2>&1 ; do # > /dev/null 2>&1 to discard possible stdout/err messages
		echo "Waiting for temporary mariadbd..."
		sleep 1
	done

	# create db and user, grant perms
	mariadb --socket=/run/mysqld/mysqld.sock <<-EOSQL
		CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;
		ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOTPASS}';
		CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_USERPASS}';
		GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
	EOSQL

	# kill temp daemon
	kill "$tmp_pid" # could be problematic? mariadb-admin -u root -p"${DB_ROOTPASS}" shutdown
	wait "$tmp_pid"
	echo "temp daemon ended with: $?"
fi

# exec main daemon as pid 1 while accepting both socket and port connections
exec mariadbd \
	--user=mysql \
	--bind-address=0.0.0.0 \
	--port=3306 \
	--datadir=/var/lib/mysql \
	--socket=/run/mysqld/mysqld.sock \
	--console