FROM ubuntu
ENV DOMAIN example.com
RUN apt-get update && apt-get install -y curl
RUN mkdir /scripts
ENTRYPOINT ["/bin/sh","/scripts/e2etests.sh"]
