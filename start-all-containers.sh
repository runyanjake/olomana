#!/bin/bash

# List of container paths to start
declare -a CONTAINERS=(
  "media/immich"
  "media/plex"
  "media/transmission"
  "misc/homepage"
  "smarthome/homeassistant"
	"software-development/design/excalidraw"
  "software-development/project-management/planka"
  "software-development/documentation/code-server"
  "software-development/documentation/docmost"
  "software-development/infrastructure/gitea"
  "software-development/infrastructure/grafana"
  "software-development/infrastructure/traefik"
)

# Start all containers in one call to start-containers.sh
./start-containers.sh "${CONTAINERS[@]}"
