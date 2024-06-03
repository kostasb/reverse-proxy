# README

## Overview

An orchestrated deployment of a sample web app and reverse proxy with generated Let's Encrypt certificates.

It creates the following containers:

- Ephemeral Git clone container to fetch an example web app https://github.com/dockersamples/linux_tweet_app.
- Ephemeral Certbot (Let's Encrypt client) container to generate certificates for the given domain name and email address.
- Sidecar Cerbot monitor container to renew certificates when expiration time approaches.
- Sample Web app bound to localhost with healthcheck.
- Nginx proxy listening on public socket. Redirects port 80 to 443 and enables SSL using the Certbot-provided certificates with healthcheck.
- Basic E2E functional tests to verify successful connection, 80-to-443 redirection and matching certificate CN.

## Prerequisites

The environment can be spun up on any host that supports the bash shell and runs a Docker server.
All actions runs within Docker containers so there are no other external dependencies at the host level.
The host must be accessible over public internet on ports 80 and 443 with a valid public DNS record.

## Manual Usage
The following scripts can be used to start, test and stop the deployment:

- `start-services.sh`: Expects `-d domain` and `-e email` parameters. Deploys all services in the environment and calls e2e tests.

    Usage example:

    ```
    ./start-services.sh -d example.com -e admin@example.com
    ```

    **Note:** [Certbot](https://certbot.eff.org/) ([Let's Encrypt](https://letsencrypt.org/getting-started/) client) will not issue certificates for private or invalid domains. A real domain name is expected and the host that its DNS record resolves to is challenged. The system that runs this environment must be publicly accessible on the published address from Let's Encrypt systems.

- `stop-services.sh`: Stops all docker containers which were spun up by `start-services.sh`.

    **Note:** Artifacts such as container layers, images and networks will remain on the Docker host even after executing the stop script. The command `docker system prune` can be used to clean up storage space.

- `e2e-tests.sh`: Expects parameter `-d domain` and runs basic tests against the target domain/web service that validate the environment's functionality: response code, redirection and matching certificate CN.

## Automated Deployment

The environment can be deployed on a target host via SSH using the included Ansible playbook.

```
ansible-playbook playbook.yml --private-key=/path/to/reverse-proxy.pem -u username -i DOMAIN, --extra-vars "email=EMAIL"
```

`DOMAIN` is the hostname of the web server as well as the CN that the certificate will be issued for. `EMAIL` is address to be associated with the certificate.

## Runtime State

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
