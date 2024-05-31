FROM certbot/certbot:latest
ENV DOMAIN example.com
ENV EMAIL admin@example.com
RUN mkdir -p /var/www/certbot/
ENTRYPOINT ["/bin/sh","/init.sh"]