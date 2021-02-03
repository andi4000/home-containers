# Traefik Minimal Example for Private (Home) Network

TODO: motivation, background, context

This docker-compose provisions a Traefik container for reverse proxy with
HTTPS/TLS enabled for the use in private/home network without a valid FQDN / domain name.

What this tries to achieve is to give HTTPS capability of all services provided
by docker containers.

## Use Case

```
                                  ______________________________________
                                 | Docker private network               |
                                 |                                      |
                                 |                                      |
                                 |             ---> Heimdall            |
Clients              HTTPS       |             |                        |
(Smartphone,      ---------> Reverse Proxy ----|--> Nextcloud           |
Set Top Box, etc.)              Traefik        |                        |
                                 |             |--> PiHole              |
                                 |             |                        |
                                 |             |--> PhotoPrism/         |
                                 |             |    PhotoStructure      |
                                 |             |                        |
                                 |             ---> etc.                |
                                 |______________________________________|

```

## Usage

1. Create local DNS entries for the domains (e.g. traefik.local) that points to
   the VM/server hosting the container. In PiHole: "Local DNS" > "CNAME
   Records".
2. `docker network create proxynet`
3. Generate TLS certificates
```bash
cd certs/
openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout cert.key -out cert.crt
# Questions will be asked, e.g. organization name, etc.
```
4. `docker-compose up -d`

## TODO
- Internal networking for all containers, traefik is the only one accessible
  from outside
- Harden docker endpoint, using TCP socket or SSH instead of Unix socket. [Ref](https://doc.traefik.io/traefik/v2.3/providers/docker/#docker-api-access).
