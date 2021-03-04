# What This Is
Docker instance for Photoprism, with photos located in NFS share. Application
database and storage (sidecar) are also stored in NFS share.

# Usage
Adjust the fields in `sample.env` and copy that file into `.env`. Check with
`docker-compose config`.

# Command Reference
```
# ------------------------------------------------------------------
# DOCKER COMPOSE COMMAND REFERENCE
# ------------------------------------------------------------------
# Start    | docker-compose up -d
# Stop     | docker-compose stop
# Update   | docker-compose pull
# Logs     | docker-compose logs --tail=25 -f
# Terminal | docker-compose exec photoprism bash
# Help     | docker-compose exec photoprism photoprism help
# Config   | docker-compose exec photoprism photoprism config
# Reset    | docker-compose exec photoprism photoprism reset
# Backup   | docker-compose exec photoprism photoprism backup -a -i
# Restore  | docker-compose exec photoprism photoprism restore -a -i
# Index    | docker-compose exec photoprism photoprism index
# Reindex  | docker-compose exec photoprism photoprism index -a
# Import   | docker-compose exec photoprism photoprism import
# -------------------------------------------------------------------
# Note: All commands may have to be prefixed with "sudo" when not running as root.
#       This will change the home directory "~" to "/root" in your configuration.
```

# References
- Documentation : https://docs.photoprism.org/getting-started/docker-compose/
- Docker Hub URL: https://hub.docker.com/r/photoprism/photoprism/
