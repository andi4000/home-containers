# Traefik Private Network Minimal Example

TODO: motivation, background, context

## Usage

1. Create local DNS entries for the domains (e.g. traefik.local) that points to
   the VM/server hosting the container. In PiHole: "Local DNS" > "CNAME
   Records".
2. `docker network create proxynet`

