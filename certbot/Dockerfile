FROM certbot/certbot:latest
RUN mkdir -p /var/www/certbot/
ENTRYPOINT ["certbot","certonly"]
CMD ["--standalone","--email=kmpotsas@gmail.com","--domains=kostasbotsas.com","--non-interactive","--agree-tos"]
