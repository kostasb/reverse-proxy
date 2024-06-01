#!/bin/sh
if ! { [ -d "/etc/letsencrypt/live/$DOMAIN" ] && [ -f "/etc/letsencrypt/live/$DOMAIN/fullchain.pem" ] && [ -f "/etc/letsencrypt/live/$DOMAIN/privkey.pem" ]; }; then
    certbot certonly --standalone --email=$EMAIL --domains=$DOMAIN --non-interactive --agree-tos
else
    certbot renew --no-random-sleep-on-renew
fi