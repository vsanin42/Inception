#!/bin/sh
set -e

sed -i '\|error_log /var/log/nginx/error.log warn;|c\error_log /dev/stdout warn;' /etc/nginx/nginx.conf
sed -i '\|access_log /var/log/nginx/access.log main;|c\access_log /dev/stdout main;' /etc/nginx/nginx.conf

cat << 'EOF' > /etc/nginx/http.d/default.conf
server {
	listen 443 ssl;
	server_name _;
	root /var/www/html;

	keepalive_timeout   70;
	ssl_certificate     /etc/ssl/certs/owowow-cert.pem;
	ssl_certificate_key /etc/ssl/private/owowow-private.key;
	ssl_protocols       TLSv1.2 TLSv1.3;
	ssl_ciphers         HIGH:!aNULL:!MD5;

	location / {
		try_files $uri $uri/ /index.php?$args;
	}
	index index.php index.html;

	location ~ \.php$ {
		try_files		$fastcgi_script_name =404;
		include			fastcgi_params;
		fastcgi_index	index.php;
		fastcgi_pass	wordpress:9000;
		fastcgi_param	SCRIPT_FILENAME $document_root$fastcgi_script_name;
	}
}
EOF

exec nginx -g 'daemon off;'