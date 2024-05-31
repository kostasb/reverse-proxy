FROM ubuntu
RUN apt-get update && apt-get install -y git
RUN mkdir -p /apps

CMD ["git","clone","-b","master","https://github.com/dockersamples/linux_tweet_app.git"]