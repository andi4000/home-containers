#!/bin/bash
# Source: https://www.smarthomebeginner.com/synology-docker-media-server/
#
# Add as scheduled task:
#   - as root
#   - run every boot
 
HTTP_PORT=81
HTTPS_PORT=444
 
sed -i "s/^\( *listen .*\)80/\1$HTTP_PORT/" /usr/syno/share/nginx/*.mustache
sed -i "s/^\( *listen .*\)443/\1$HTTPS_PORT/" /usr/syno/share/nginx/*.mustache
