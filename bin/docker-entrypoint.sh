#!/bin/bash
set -eo pipefail

if [[ "$1" == apache2* ]] || [ "$1" == php-fpm ]; then
	if [ "$(id -u)" = '0' ]; then
		case "$1" in
			apache2*)
				user="${APACHE_RUN_USER:-www-data}"
				group="${APACHE_RUN_GROUP:-www-data}"
				;;
			*) # php-fpm
				user='www-data'
				group='www-data'
				;;
		esac
	else
		user="$(id -u)"
		group="$(id -g)"
	fi

	uniqueEnvs=(
		AUTH_KEY
		SECURE_AUTH_KEY
		LOGGED_IN_KEY
		NONCE_KEY
		AUTH_SALT
		SECURE_AUTH_SALT
		LOGGED_IN_SALT
		NONCE_SALT
	)
	if [ $WORDPRESS_DB_HOST ] && [ ! -e production-config.php ]; then
    cp production-config.template production-config.php
		chown "$user:$group" production-config.php
	  for unique in "${uniqueEnvs[@]}"; do
      echo "define( '$unique', '$(head -c1m /dev/urandom | sha1sum | cut -d' ' -f1)' );" >> production-config.php
	  done
	fi
fi

exec "$@"
