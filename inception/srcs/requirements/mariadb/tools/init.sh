#!/bin/bash
set -eo pipefail

check_secret() {
    local secret_path="$1"
    if [[ ! -f "$secret_path" ]]; then
        printf "Error: secret missing at %s\n" "$secret_path" >&2
        return 1
    fi
}

check_secret "/run/secrets/root_password" || exit 1
check_secret "/run/secrets/user_password" || exit 1

MYSQL_ROOT_PASSWORD=$(< /run/secrets/root_password tr -d '\r\n')
MYSQL_PASSWORD=$(< /run/secrets/user_password tr -d '\r\n')

if [[ ! -d "/var/lib/mysql/mysql" ]]; then
    echo "Initializing MariaDB system tables..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql --skip-test-db > /dev/null
fi

echo "Applying database initialization and user privileges..."
mariadbd --user=mysql --bootstrap << EOF
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

echo "Starting MariaDB daemon..."
exec "$@"