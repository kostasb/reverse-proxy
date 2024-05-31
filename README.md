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

    **Note:** [Certbot](https://certbot.eff.org/) ([Let's Encrypt](https://letsencrypt.org/getting-started/) client) will not issue certificates for private or invalid domains. A real domain name is expected, and the IP/host its DNS record resolves to will be challenged against the system that runs this environment.

- `stop-services.sh`: Stops all the docker-compose containers which were spun up by `start-services.sh`.

    **Note:** Artifacts such as container layers, images and networks will remain on the Docker host even after executing the stop script. The command `docker system prune` can be used to clean up storage space.

- `e2e-tests.sh`: Expects parameter `-d domain` and runs basic functional tests against the target domain/web service that validate the environment's characteristics: response code, redirection and certificate match.