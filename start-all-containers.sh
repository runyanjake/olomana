#!/bin/bash

# List of container paths to start
declare -a CONTAINERS=(
  "home/homeassistant"
  "media/immich"
  "media/plex"
  "media/transmission"
  "misc/homepage"
  "productivity/code-server"
  "productivity/planka"
  "software/workflow/n8n"
  "software-development/gitea"
  "software-development/grafana"
  "software-development/traefik"
)

# Start all containers in one call to start-containers.sh
./start-containers.sh "${CONTAINERS[@]}"
