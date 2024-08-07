# Olomana - All in One
This is the one-dockerfile version of olomana containing the stable "production" containers. 
Better than going module by module but don't let that stop you.  
Run everything with a simple `docker-compose down && docker system prune && docker-compose up -d`  
Run one thing with a simple `docker-compose up serviceName`

## Setup

### Traefik

#### Instructions

##### Files
Create/Fill in the following files in a `traefik/` directory under this one using the provided templates:
- `traefik.toml`
- `traefik-dynamic.toml`. 

The file `traefik/acme.json` will be generated on first run. Make sure it eventually gets permission code 600. You might need to create a blank file before the first run.

##### Volumes
Mount each of these files into the container, including the docker socket:
- `/var/run/docker.sock:/var/run/docker.sock:ro`
- `./traefik/traefik.toml:/etc/traefik/traefik.toml`
- `./traefik/traefik-dynamic.toml:/etc/traefik/dynamic/traefik-dynamic.toml`
- `./traefik/acme.json:/etc/acme.json`

#### References
https://doc.traefik.io/traefik/getting-started/quick-start/  
https://doc.traefik.io/traefik/user-guides/docker-compose/basic-example/

### Code-Server

#### Instructions

##### Volumes
Mount the persistant storage somewhere.
- `/pwspool/software/code-server/config:/config`

##### Metadata
Re-roll hashed passwords. 

#### References
https://docs.linuxserver.io/images/docker-code-server/  
https://coder.com/docs/code-server/latest/install#docker  
https://hub.docker.com/r/linuxserver/code-server  
https://github.com/coder/code-server/blob/main/docs/FAQ.md#can-i-store-my-password-hashed
