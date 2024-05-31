FROM certbot/certbot:latest
RUN apk add coreutils
RUN mkdir -p /var/www/certbot/
ENTRYPOINT ["/bin/sh","/renewloop.sh"]