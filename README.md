# Home Services Docker Container

This contains docker provisioning scripts for services running in docker
container on my NAS.

To be used together with Ansible VM provisioning script. TODO: link.

## Overview

Traefik is the main point of contact from outside for all services. It provides
reverse proxying with domain name access, e.g. `https://portainer.YOURDOMAIN.com` instead
of `https://vm03.lan:1337`. Also valid HTTPS certificate from LetsEncrypt is very nice.

This requires a valid public domain name (ca. 5 EUR/year), and public DNS entry pointing
to the VM private IP address. Your VM/server's IP address will be public, yes. Is it insecure?
I don't think so. It's one step away from IP scan anyway.

Additionally you could add wildcard CNAME record pointing to the VM for
automatic DNS resolving. With this, other services can be deployed on demand, with only
docker label necessary in each container pushing dynamic configuration to Traefik.

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
      - "traefik.http.routers.my-app.rule=Host(`my-app.YOURDOMAIN.com`)"
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

docker network create traefiknet
```

Move ports 80 and 443 by Nginx of Synology so that traefik can handle that:
See [this script](scripts/startup_script_for_traefik.sh)

