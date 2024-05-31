FROM ubuntu
RUN apt-get update && apt-get install -y curl
RUN mkdir /scripts
ENTRYPOINT ["/bin/sh","/scripts/e2etests.sh"]
