# Home Services Docker Container

This contains docker provisioning scripts for services running in docker
container on my NAS.

To be used together with Ansible VM provisioning script. TODO: link.

## Overview

Traefik is the main point of contact from outside for all services. It provides
reverse proxying with domain name access, e.g. `https://portainer.lan` instead
of `https://vm03.lan:1337`. The other services are deployed on demand, with
two necessary settings:

- DNS CNAME pointing at docker host's IP address
- docker labels in each container pushing dynamic configuration to Traefik

e.g.

```yaml
# ...
services:
  my-app:
    # ...
    labels:
      # Ref: https://traefik.io/blog/traefik-2-tls-101-23b4fbee81f1/
      - "traefik.enable=true"
      - "traefik.docker.network=traefiknet"  # if container has multiple networks
      - "traefik.http.routers.my-app.rule=Host(`my-app.lan`)"
      - "traefik.http.routers.my-app.tls=true"
```

## Use Case

```
                                    ____________________________________
                                   | Docker private network             |
                                   |                                    |
                                   |                                    |
                                   |           ---> Heimdall            |
Clients              HTTPS         |           |                        |
(Smartphone,      ---------> Reverse Proxy ----|--> Nextcloud           |
Set Top Box, etc.)              Traefik        |                        |
                                   |           |--> PiHole              |
                                   |           |                        |
                                   |           |--> PhotoPrism/         |
                                   |           |    PhotoStructure      |
                                   |           |                        |
                                   |           |--> Portainer           |
                                   |           |                        |
                                   |           ---> etc.                |
                                   |____________________________________|

```

## Usage

Prep:
```bash
# On vanilla Ubuntu 20.04
sudo apt install docker.io
sudo apt install python3-pip
sudo pip3 install docker-compose
sudo usermod -aG docker $(whoami)
newgrp docker
```
