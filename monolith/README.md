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
In addition to the above files, make sure the docker socket is mounted:
- `/var/run/docker.sock:/var/run/docker.sock:ro`

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
./olomana.ini:/etc/grafana/grafana.ini
#### References
https://docs.linuxserver.io/images/docker-code-server/  
https://coder.com/docs/code-server/latest/install#docker  
https://hub.docker.com/r/linuxserver/code-server  
https://github.com/coder/code-server/blob/main/docs/FAQ.md#can-i-store-my-password-hashed

### Grafana

#### Instructions

##### Files
Create/Fill in the following files in a `grafana` directory under this one using the templates.
- `grafana.ini`
- `prometheus.yml`

##### Volumes
Make sure that in additionto mounting the 2 files above to their respective containers, grafana container has the following mount:
- `/pwspool/software/grafana:/var/lib/grafana`

Also make sure that the correct user has access to the folder on the host machine, sometimes grafana won't start up otherwise.

##### Grafana Setup
To set up the data source in grafana to point to prometheus, you would refer to `http://prometheus:9090`.

#### References
https://grafana.com/docs/grafana/latest/setup-grafana/installation/docker/



