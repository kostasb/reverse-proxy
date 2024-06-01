FROM nginx:latest
ENV DOMAIN example.com

COPY ./conf/proxy_params /etc/nginx/proxy_params
COPY ./conf/nginx.conf /etc/nginx/templates/nginx.conf.template

RUN mkdir -p /etc/nginx/ssl

EXPOSE 80 443 	

CMD ["nginx", "-g", "daemon off;"]