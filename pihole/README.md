# PiHole with Traefik Reverse Proxy

# TODO:
- DNS over HTTPS? Port 853?
- What do PiHole need port 443 open for?
- write data to persistent volume on NAS for e.g. static DNS CNAME list
- web admin password, check `environments` tag
- chicken and egg problem --> how problematic is it when the DNS server is
  running inside a container, hidden behind reverse proxy, which runs on a VM,
  which runs on a NAS? Especially with `systemd-resolved` disabled
- Put all below here into ansible routine

## Done
- Docker host can't resolve mDNS/Avahi hosts --> use `REV_SERVER*` environment
  variables
- Fix host's DNS setting: [documentation](https://github.com/pi-hole/docker-pi-hole/#installing-on-ubuntu)

## Usage
`systemd-resolved` is blocking port 53, thus making PiHole and Traefik unable to
start. But without it, the server won't have domain name resolution. So the
trick is:

1. `docker pull pihole/pihole:latest` to download pihole image
2. `sudo service systemd-resolved stop`
3. Make sure `systemd-resolved` completely ded: `ps aux | grep resolved`

Then proceed with PiHole:

4. Start PiHole and Traefik
5. Make sure Traefik publishes port 53 TCP and UDP:

```bash
$ docker port <TRAEFIK_CONTAINER_NAME>
443/tcp -> 0.0.0.0:443
53/tcp -> 0.0.0.0:53
53/udp -> 0.0.0.0:53
80/tcp -> 0.0.0.0:80
```

6. Check with `nslookup` from other client (e.g. your laptop) if the PiHole is
   resolving DNS properly:

```bash
$ nslookup google.com vm03  # or replace vm03 with IP or hostname of docker host
Server:         vm03
Address:        10.0.1.4#53

Non-authoritative answer:
Name:   google.com
Address: 172.217.168.238
Name:   google.com
Address: 2a00:1450:400e:80d::200e

$ nslookup googleadservices.com 1.1.1.1  # Cloudflare's DNS doesn't block evil domain
Server:         1.1.1.1
Address:        1.1.1.1#53

Non-authoritative answer:
Name:   googleadservices.com
Address: 142.250.186.130

$ nslookup googleadservices.com vm03  # PiHole does
Server:         vm03
Address:        10.0.1.170#53

Name:   googleadservices.com
Address: 0.0.0.0
Name:   googleadservices.com
Address: ::

```

7. Set IP address of the docker host to be system-wide DNS resolver on your
   network
8. Fix DNS setting of docker host
    1. set `DNSStubListener=no` in `/etc/systemd/resolved.conf`
    2. `sudo mv /etc/resolv.conf /etc/resolv.conf.orig`
    3. `sudo ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf`
    4. `sudo systemctl restart systemd-resolved`
    5. configure your netplan in `/etc/netplan/*.yaml` like this example:
        ```yaml
        network:
            ethernets:
                enps0e4:
                    dhcp4: true
                    dhcp4-overrides:
                        use-dns: false
                    nameservers:
                        addresses: [127.0.0.1]
            version: 2
        ```
    6. `sudo netplan apply`
    7. check if `/etc/resolv.conf` contains `127.0.0.1` as nameserver


## References:
- https://www.reddit.com/r/pihole/comments/fy8zmu/pihole_traefik_dnsovertls/
- https://www.smarthomebeginner.com/run-pihole-in-docker-on-ubuntu-with-reverse-proxy/
- https://sensepost.com/blog/2020/building-a-hipster-aware-pi-home-server/
