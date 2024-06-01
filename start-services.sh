#!/bin/sh
BOOT_WAIT_TIME=10
usage="$(basename "$0") [-d] [-e] -- Start Certbot, Nginx reverse proxy and App.\nRequired parameters:\n -d CN\n -e email"

while getopts d:e:h flag
do
    case "${flag}" in
        d) DOMAIN=${OPTARG};;
        e) EMAIL=${OPTARG};;
        h) echo "$usage"
            exit;;
    esac
done

if [ -z ${DOMAIN+x} ]; then echo "Error: missing domain parameter (-d)\n"; exit -1; fi
if [ -z ${EMAIL+x} ]; then echo "Error: missing email parameter (-e)\n"; exit -1; fi

echo "DOMAIN=$DOMAIN\nEMAIL=$EMAIL" > .env

echo "Creating container to run git clone"
docker build -t gitclone gitclone >/dev/null 2>&1
if [ "$?" -eq 0 ]; then
    docker run -v ./gitclone/apps:/apps:rw -v ./gitclone:/scripts:rw gitclone -e DOMAIN=$DOMAIN -e EMAIL=$EMAIL
fi
if [ "$?" -eq 0 ];
then
    echo "Starting services"
    docker compose up --build -d
    echo "Waiting $BOOT_WAIT_TIME seconds for services to boot before initiating e2e tests..."
    sleep $BOOT_WAIT_TIME
    ./e2e-tests.sh -d $DOMAIN
else
    echo "Error - could not clone linux_tweet_app"
fi