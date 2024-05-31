#!/bin/sh
echo "Creating git container"
docker build -t gitclone gitclone >/dev/null 2>&1
if [ "$?" -eq 0 ]; then
    docker run -v ./gitclone/apps:/apps:rw -v ./gitclone:/scripts:rw gitclone
fi
if [ "$?" -eq 0 ];
then
    echo "Starting services"
    docker compose up -d
    echo "Waiting for services to initialize..."
    sleep 10
    ./e2e-tests.sh
else
    echo "Error - could not clone linux_tweet_app"
fi