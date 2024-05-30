#!/bin/sh
while :; do
    sleep 1h
    nginx -t && nginx -s reload
done &