FROM nginx:latest
ENV DOMAIN example.com
COPY ./conf/nginx.conf /etc/nginx/nginx.conf
COPY ./conf/proxy_params /etc/nginx/proxy_params

RUN mkdir -p /etc/nginx/ssl

EXPOSE 80 443 	

CMD ["nginx", "-g", "daemon off;"]