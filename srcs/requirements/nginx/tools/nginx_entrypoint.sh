#!/bin/sh
set -e

# cd and env checks can be redundant
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
	[ -z "$WP_USER_EMAIL" ]; then
	echo "Missing value(s) of variable(s), exiting"
	exit 1
fi

# might need to overwrite nginx.conf for tls things

# overwrite nginx default.conf - server, location, fastcgi_abc...
cat << 'EOF' > /etc/nginx/http.d/default.conf
server {
	listen 8080 default_server;
	server_name _;
	root /var/www/html;

	location / {
		try_files $uri $uri/ /index.php?$args;
	}

	location ~ \.php$ {
		try_files $fastcgi_script_name =404;
		include			fastcgi_params;
		fastcgi_pass	wordpress:9000;
		fastcgi_param	SCRIPT_FILENAME $document_root$fastcgi_script_name;
	}
}
EOF

exec nginx -g 'daemon off;'