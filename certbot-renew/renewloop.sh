#!/bin/sh
while :; do
    /bin/sleep 1h
    certbot renew --no-random-sleep-on-renew
done