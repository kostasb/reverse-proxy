#!/bin/sh
UNIQUE_ID=$(date +%s)
docker build -t gitclone gitclone
docker run -v ./gitclone/apps:/apps:rw gitclone git clone -b master https://github.com/dockersamples/linux_tweet_app.git "/apps/linux_tweet_app_$UNIQUE_ID"
if [ "$?" -eq 0 ]
then
    UNIQUE_ID=$UNIQUE_ID docker compose up -d
else
    echo "gitclone error"
fi