#!/bin/bash
set -e

echo "Checking MariaDB availability..."
until nc -z mariadb 3306; do
    sleep 2
done

echo "MariaDB is ready. Checking WordPress setup..."

WP_PATH="/var/www/html"

if [ -f "$WP_PATH/wp-config.php" ]; then
    echo "WordPress is already installed and configured."
else
    echo "Downloading WordPress core files..."
    wp core download --path="$WP_PATH" --allow-root

    MYSQL_PASSWORD=$(cat /run/secrets/user_password | tr -d '\r\n')
    WP_ADMIN_PASSWORD=$(cat /run/secrets/admin_password | tr -d '\r\n')
    WP_USER_PASSWORD=$(cat /run/secrets/client_password | tr -d '\r\n')

    echo "Generating wp-config.php..."
    wp config create \
        --path="$WP_PATH" \
        --dbname="$MYSQL_DATABASE" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$MYSQL_PASSWORD" \
        --dbhost="mariadb:3306" \
        --allow-root

    echo "Running WordPress core install..."
    wp core install \
        --path="$WP_PATH" \
        --url="$DOMAIN_NAME" \
        --title="Inception" \
        --admin_user="$WP_ADMIN_USERNAME" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --allow-root

    echo "Adding secondary user..."
    wp user create "$WP_USER" "$WP_USER_EMAIL" \
        --path="$WP_PATH" \
        --role=author \
        --user_pass="$WP_USER_PASSWORD" \
        --allow-root

    chown -R www-data:www-data "$WP_PATH"
    echo "WordPress configuration completed."
fi

exec "$@"
