#!/bin/bash

# List of container paths to start
declare -a CONTAINERS=(
  "ai/openwebui"
  "home/homeassistant"
  "media/immich"
  "media/plex"
  "media/transmission"
  "misc/homepage"
  "software-development/code-server"
  "software-development/grafana"
  "software-development/traefik"
)

# Start all containers in one call to start-containers.sh
./start-containers.sh "${CONTAINERS[@]}"
