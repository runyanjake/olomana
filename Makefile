MODULES = traefik code-server covid19 gitea grafana homepage jenkins minecraft monica nordvpn photoprism plex portainer
DOCKER_COMPOSE_DOWN = docker-compose down
DOCKER_PRUNE = docker system prune -f
DOCKER_COMPOSE_UP = docker-compose up -d
DOCKER_COMPOSE_BUILD = docker-compose build
DOCKER_START = $(DOCKER_COMPOSE_DOWN) && $(DOCKER_PRUNE) && $(DOCKER_COMPOSE_UP)
DOCKER_BUILD = $(DOCKER_COMPOSE_DOWN) && $(DOCKER_PRUNE) && $(DOCKER_COMPOSE_BUILD) && $(DOCKER_COMPOSE_UP)
DOCKER_NETWORK_CREATE = docker network create

.PHONY: $(MODULES)

all: $(MODULES)

code-server:
	cd code-server && $(DOCKER_BUILD)

covid19:
	cd covid19/covidapp-repo && docker build --tag="kr/covidapp" .
	cd covid19 && $(DOCKER_START)
	@echo "Setup complete, see README.md for instructions on seeding database."

gitea:
	cd gitea && $(DOCKER_BUILD)

grafana: minecraft
	cd grafana && $(DOCKER_COMPOSE_BUILD) && $(DOCKER_COMPOSE_UP)

homepage:
	cd homepage && $(DOCKER_BUILD)

jenkins:
	cd jenkins && $(DOCKER_BUILD)

minecraft:
	cd minecraft && $(DOCKER_NETWORK_CREATE) grafana_grafana-network && $(DOCKER_COMPOSE_UP)

monica:
	cd monica && $(DOCKER_BUILD)

nordvpn:
	cd nordvpn && $(DOCKER_BUILD)

photoprism:
	cd photoprism && $(DOCKER_BUILD)

plex:
	cd plex && $(DOCKER_BUILD)

portainer:
	cd portainer && $(DOCKER_BUILD)

traefik:
	cd traefik && $(DOCKER_NETWORK_CREATE) traefik_traefik-network && $(DOCKER_COMPOSE_UP)

