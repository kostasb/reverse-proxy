# README

## Overview

Web server environment orchestration that receives as arguments a domain name and email and deploys:

- A container that git clones an example web app https://github.com/dockersamples/linux_tweet_app.
- Ephemeral Certbot (Let's encrypt) contain that generates certificates for the given domain name and email address.
- Persistent Cerbot container to checks and renew certificates when they approach expiration time.
- Example Web app bound to localhost, with healthcheck.
- Nginx proxy that listens on public socket, redirects port 80 to 443 and enables SSL with the Certbot-provided certificates, with healthcheck.
- E2E functional tests that verify public port availability, 80-to-443 redirection and certificate CN.

## Prerequisites

There are no external dependencies. Since all action run within Docker, this repo is compatible with any host that supports bash and Docker.

## Usage
The following scripts can be used to manage the environment:

- `start-services.sh`: Expects `-d domain` and `-e email` parameters. Deploys all services in the environment and calls e2e tests.

    Usage example:

    ```
    ./start-services.sh -d example.com -e admin@example.com
    ```

    **Note:** [Certbot](https://certbot.eff.org/) ([Let's Encrypt](https://letsencrypt.org/getting-started/) client) will not issue certificates for private or invalid domains. A real domain name is expected and the host that its DNS record resolves to is challenged. The system that runs this environment must be publicly accessible on the advertised address from Let's Encrypt systems.

- `stop-services.sh`: Stops all the docker-compose containers which were spun up by `start-services.sh`.

    **Note:** Artifacts such as container layers, images and networks will remain on the Docker host even after executing the stop script. The command `docker system prune` can be used to clean up storage space.

- `e2e-tests.sh`: Expects parameter `-d domain` and runs basic functional tests against the target domain/web service that validate the environment's characteristics: response code, redirection and certificate match.

### Runtime State

The `gitclone`, `certbot` and `e2etests` containers only run ephemerally.
The persistent containers that can be found in the `docker ps` output once the environment is fully initiallized are:

- `nginx`: Serves the public endpoint and acts as reverse proxy to the linux_tweet_app. Reloads periodically to pick up new certificates if needed.
- `linux_tweet_app`: Binds on local endpoint and serves the app site.
- `certbot_renew`: Monitors certificate validity and renews them if needed.

```
% docker ps
CONTAINER ID   IMAGE                  COMMAND                  CREATED          STATUS                    PORTS                                      NAMES
9092794a430e   test-nginx             "/docker-entrypoint.…"   57 minutes ago   Up 52 seconds (healthy)   0.0.0.0:80->80/tcp, 0.0.0.0:443->443/tcp   test-nginx-1
405c6c3d92da   test-linux_tweet_app   "/docker-entrypoint.…"   57 minutes ago   Up 53 seconds (healthy)   443/tcp, 127.0.0.1:8080->80/tcp            test-linux_tweet_app-1
38dfc2d9c054   test-certbot_renew     "/bin/sh /renewloop.…"   57 minutes ago   Up 53 seconds             80/tcp, 443/tcp                            test-certbot_renew-1
```

## Diagram

![diagram](https://github.com/kostasb/reverse-proxy/assets/15780449/9aa595b0-1115-479c-aef3-277c4e12c184)
