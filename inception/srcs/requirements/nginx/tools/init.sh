#!/bin/bash
set -e

if [ -f "/etc/ssl/certs/nginx-selfsigned.crt" ]; then
    echo "SSL Certificate already exists."
else
    echo "Creating new self-signed certificate..."
    openssl req -x509 -nodes -days 365 \
        -newkey rsa:2048 \
        -keyout /etc/ssl/private/nginx-selfsigned.key \
        -out /etc/ssl/certs/nginx-selfsigned.crt \
        -subj "/C=MO/ST=Rabat/L=Sale/O=42/OU=42/CN=${DOMAIN_NAME}/UID=${SSL_USERNAME}"
fi

exec "$@"