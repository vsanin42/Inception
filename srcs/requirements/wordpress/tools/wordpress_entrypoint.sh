#!/bin/sh
set -e

cd /var/www/html

if	[ -z "$DOMAIN_NAME" ] || \
	[ -z "$DB_HOST" ] || \
	[ -z "$DB_NAME" ] || \
	[ -z "$DB_USER" ] || \
	[ -z "$DB_USERPASS" ] || \
	[ -z "$WP_TITLE" ] || \
	[ -z "$WP_ADMIN" ] || \
	[ -z "$WP_ADMIN_PASS" ] || \
	[ -z "$WP_ADMIN_EMAIL" ] || \
	[ -z "$WP_USER" ] || \
	[ -z "$WP_USER_PASS" ] || \
	[ -z "$WP_USER_EMAIL" ] || \
	[ -z "$WP_PUBLIC_URL" ]; then
	echo "Missing value(s) of variable(s), exiting"
	exit 1
fi

while ! mariadb-admin ping -h "$DB_HOST" -u "$DB_USER" -p"$DB_USERPASS" >/dev/null 2>&1 ; do
	echo "Waiting for mariadb..."
	sleep 1
done

if [ ! -f /var/www/html/wp-config.php ]; then
	echo "Wordpress config missing, creating..."
	wp config create --allow-root \
					 --dbhost="$DB_HOST" \
					 --dbname="$DB_NAME" \
					 --dbuser="$DB_USER" \
					 --dbpass="$DB_USERPASS"
fi

if ! wp core is-installed --allow-root >/dev/null 2>&1; then
	echo "Wordpress not installed, installing..."
	wp core install --allow-root \
					--url="$DOMAIN_NAME" \
					--title="$WP_TITLE" \
					--admin_user="$WP_ADMIN" \
					--admin_email="$WP_ADMIN_EMAIL" \
					--admin_password="$WP_ADMIN_PASS" \
					--skip-email

	wp option update home "$WP_PUBLIC_URL" --allow-root
	wp option update siteurl "$WP_PUBLIC_URL" --allow-root

	wp user create --allow-root "$WP_USER" "$WP_USER_EMAIL" --user_pass="$WP_USER_PASS"
fi

chown -R www-data:www-data /var/www/html

exec php-fpm83 -F