# Traefik Minimal Example for Private (Home) Network

TODO: motivation, background, context

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
- Harden docker endpoint, using TCP socket or SSH instead of Unix socket. [Ref,](https://doc.traefik.io/traefik/v2.3/providers/docker/#docker-api-access)
