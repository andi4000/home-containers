# Traefik Minimal Example for Private (Home) Network

This docker-compose provisions a Traefik container for reverse proxy with
LetsEncrypt wildcard certificate for all services behind it. Valid public
domain name is required, and this **will only work within your home network**.

What this tries to achieve:
- To give domain names to each services running on docker, `http://portainer.YOURDOMAIN.com`
  instead of `http://vm03.lan:1337`
- Valid HTTPS for all


## Requirements
- Public domain name
- Public DNS A Record pointing to private address of the VM (I use Cloudflare)
- Wildcard CNAME record pointing to the A record previously set

```
A 	example.com 	192.168.0.10  	# exposes your private IP, no big deal
CNAME	*		example.com	# wildcard for all subdomain
```

- API token for DNS zone edit (very easy and free with Cloudflare). Instruction [here](https://go-acme.github.io/lego/dns/cloudflare/#api-tokens).


## Usage

- `docker network create traefiknet`
- edit `sample.env` with your domain name and Cloudflare API key, then `cp sample.env .env`
- `docker-compose up -d`
- `docker-compose logs -f` to see if traefik is initialized
- open `https://whoami.YOURDOMAIN.com` from browser, if no warning due to self-signed cert is shown, it means success!


## TODO
- Harden docker endpoint, using TCP socket or SSH instead of Unix socket. [Ref](https://doc.traefik.io/traefik/v2.3/providers/docker/#docker-api-access).

## Possible Extension
- htaccess username and password for Traefik dashboard --> [Reference](https://medium.com/@containeroo/traefik-2-0-docker-a-simple-step-by-step-guide-e0be0c17cfa5)
