#!/bin/sh
if ! { [ -d "/etc/letsencrypt/live/kostasbotsas.com" ] && [ -f "/etc/letsencrypt/live/kostasbotsas.com/fullchain.pem" ] && [ -f "/etc/letsencrypt/live/kostasbotsas.com/privkey.pem" ]; }; then
    certbot certonly --standalone --email=kmpotsas@gmail.com --domains=kostasbotsas.com --non-interactive --agree-tos
else
    certbot renew --no-random-sleep-on-renew
fi