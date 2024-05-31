#!/bin/sh
if [ -d "/apps/linux_tweet_app" ]; then
    cd /apps/linux_tweet_app
    isgit=`git rev-parse --is-inside-work-tree`
    if [ $isgit = "true" ]; then
        ismaster=`git rev-parse --abbrev-ref HEAD`
        if ! [ $ismaster = "true" ]; then
            echo "Existing linux_tweet_app clone found. Running git pull..."
            git pull
        else
            echo "linux_tweet_app code repo has deviated. An unrecognized branch was found for linux_tweet_app. Reconcile or cleanup the git state in /apps/linux_tweet_app."
        fi
    fi
else
    git clone --depth=1 -b master https://github.com/dockersamples/linux_tweet_app.git /apps/linux_tweet_app
fi