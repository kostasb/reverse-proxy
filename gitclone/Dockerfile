FROM ubuntu
RUN apt-get update && apt-get install -y git
RUN mkdir /apps
RUN mkdir /scripts
ENTRYPOINT ["/bin/sh","/scripts/gitclone.sh"]
