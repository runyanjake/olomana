# olomana
The PWS 2.0 redesign, successor to https://github.com/runyanjake/whitney.


## Background

Whitney was the codename for my first homelab setup (For reference: https://www.reddit.com/r/homelab/). It was built out of my friend's handmedown hardware in an old server case that was e-wasted from school. This initial build was on the "janky" side, featuring an unmounted power supply in the optical bay, secured only by some green yarn. (Fire hazard, anyone?)

[Picture Here]

I ran a lot of services from this box - my personal website/online resume, side projects, a Covid-19 data tracker, game servers, and a lot of other projects that taught me lessons in DNS config, networking, maintaining persistent storage and others. 

But eventually I started running up against the limits of the box. The machine's CPU was released in 2008, which was indicative of the age of most of its hardware. After spending a lot of work on the original Whitney config in the first repo, I decided that I had learned enough to warrant an upgrade.


## The Upgrade

PWS 2.0 was given the nickname of "Olomana", a second step in this pattern of mountainous server names. Mount Olomana (https://en.wikipedia.org/wiki/Olomana\_(mountain)) is a mountain on the Windward side of Oahu, Hawaii. It has 3 peaks which are are a popular, albeit difficult and dangerous hike. While visiting family in Kailua, I hiked the Ko'olau range and snapped this picture of the rarely seen backside of Mount Olomana.

Olomana, the web server will be a significant upgrade over its predecessor. I am building it as a 4U rack-mounted machine with new components. The 16U rack it is mounted in was sourced from the popular website www.racksolutions.com. The build itself includes a number of current gen budget components. Cricital resources like Ram and CPU cores are more abundant in the new build. I got a UPS and a dedicated write drive that were tested on PWS 1.0 to combat some data corruption issues I had faced on the old hardware.

[Picture here]

## Setup / Installation Instructions

In order to speed up how fast I can wipe and rebuild the server, I am maintaining this repository as a stamp of the Olomana config, as well as a instruction manual for myself to remember in what order components should be installed.


## Part 1: Initial Configuration

Olomana is based off of the latest stable version of Ubuntu Server (https://ubuntu.com/download/server)

### Mounting Hard Drives

Managing disk partitions using `gdisk` and configuring drives for automatic mounting using the `fstab` file. Example: https://techguides.yt/guides/how-to-partition-format-and-auto-mount-disk-on-ubuntu-20-04/

Created a `/data/write` and `/data/persistent` mount point that my config is based on. Applications that write frequently do so to the dedicated drive mounted at `/data/write`, and persistent data is written to `/data/persistent`.

### OpenSSH installation

`sudo apt-get install openssh-server`

Test you can ssh to the machine over the local internet. 

Port forward port 22 on the gateway.

Try connecting to the public IP/via domain if DNS is set up already.

### Docker Installation

1. Install Docker, following https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04.

2. In the same article, follow instructions to allow the main user to execute the docker command without sudo. 

3. (Optional) If the docker service does not start containers on system reboot, the service can be modified so that it starts when the machine is power cycled.

4. Install Docker-Compose additionally, following https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-compose-on-ubuntu-20-04

### Misc Setup

1. Create a new SSH key for Olomana and add it to Github: https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent

2. Install Github CLI (gh). I prefer to add the library and install with apt rather than installing some other package manager: https://www.techiediaries.com/install-github-cli-ubuntu-20/

3. Add the new SSH key created in step (1) to Github. 

4. Authenticate with Github (`gh auth login`) using a personal access token. Create this at `Settings > Developer Settings > Personal Access Token`. The access token must be given the `workflow`, `admin::publickey`, and `read::org` privs.

5. Clone this repo somewhere.


## Part 2: Services Configuration

*Note when using Traefik that services need 1. to have their UI ports allowed through the machine's firewall, and 2. must have labels declared for Traefik to pick up.*

### Network Router (Traefik)

Traefik is the networking stack that I'm using for Olomana. The goal here is to define the basic configuration for the Traefik container so that later containers can just be plugged into Traefik as necessary. 

1. Follow the instructions in the `traefik/` folder to run the example traefik configs and confirm that they are reachable.

2. Fill out the "Blanked" Traefik config and set up the final Traefik container.

3. Ensure that the DNS is setup correctly (External step, I am using Cloudflare.) so that we can route to the server via the vanity URL.

4. Expose port 8080 in the firewall so traffic can be routed to Traefik: `sudo ufw allow 8080`

5. (Additional) Configure the admin console and generate passwords for the admin user.

**Note that often I had to restart traefik after bringing up other services.**

**Also note that the network that Traefik is set up to scrape needs to match the actual network that docker has, not necessarily what is in traefik.toml. For example traefik-network and traefik_traefik-network have been mixed up for me in the past.**

### Docker Admin Console (Portainer)

1. Start portainer using the docker-compose file: `docker-compose up -d`.

2. The UI is available by default on port `9443`. I have changed the config to make it available on port `9000` instead.

3. Confirm that the admin user can login. Update the admin password.

4. Check Traefik routing for Portainer and make the login page available over `admin.whitney.rip`.

### System Metrics (Grafana, Prometheus, Node-Exporter)

Grafana, Prometheus, and Node-Exporter were originally separate configs in the Whitney config due to a circular dependancy. I made an attempt to unify them in the Olomana config. 

A bridge network is used to allow Prometheus to query Node-Exporter for metrics. Grafana connects to Prometheus via the bridge network as well to query for time series info. 

1. Start the containers using the docier-compose file: `docker-compose up -d`. 

2. Prometheus serves over port 9090. Node-Exporter serves over port 995. Grafana serves over port 3000. Confirm that only grafana is available to Traefik as `grafana.whitney.rip`.

To test that metrics are working, import the dashboard `1860`, a basic node-exporter dashboard.

When customizing dashboards, adding images can be done by hosting them on Imgur and linking them inside a Text Panel in an `<img>` html tag.

### Jenkins

1. Followed instructions at https://dev.to/andresfmoya/install-jenkins-using-docker-compose-4cab

Note that the container name is different, so for the command to get the one time password is different too: `docker exec jenkins_olomana cat /var/jenkins_home/secrets/initialAdminPassword`

2. Check Traefik routing for Jenkins, and make available on `jenkins.whitney.rip`.

### Plex

When navigating to the plex home page for the first time setup, remember to start by going to `http://[ip-address]:32400/web/index.html`. The plain address shows nothing until the plex is configured.

1. The container expects a certain folder structure. Create the following or mount a drive to `/data/ersistent that contains the following: 

- `/data/persistent/plex/tvseries`

- `/data/persistent/plex/movies`

- `/data/persistent/plex/homevideos`

- `/data/persistent/plex/transcode`

**NOTE:** If Docker has been installed with snap, while installing the OS, you'll have issues here. It's better to seperately install docker-ce and docker-compose.

2. Start the container using the docker-compose file: `docker-compose up -d`.

3. Ensure there aren't any Traefik routes for plex.

### Covid 19 Project

1. Clone `https://github.com/KevRunAmok/Covid19app` (dockerized by me!) to a subfolder and follow its instructions to built a image from it.  

2. Create that the `./schema` folder has been created. If a sql dump file has been provided, put them in there, and ensure that they are named in such a way that the alphanumeric execution order executes the schema one before the data one.

3. Start the container using the docker-compose file: `docker-compose up -d` and wait until it is ready to accept connections.

4. Create a user who can query the tables:

- `docker exec -it mysql_whitney mysql -uroot -proot`

- `select * from mysql.user;` / `select Host, User from mysql.user;`

- `CREATE USER 'kr_covid'@'%' IDENTIFIED BY 'kr_covid';`

- `ALTER USER 'kr_covid'@'%' IDENTIFIED WITH mysql_native_password BY 'covid123';`

- `GRANT ALL ON sql_covid19.\* to 'kr_covid'@'%';`

After adding the user, you can exec onto the container and run mysql from there to test.

5. Import any data. Normally this is handled automatically, but if the files copied to `/docker-entrypoint-initdb.d/` are not running you can pipe them to mysql manually. 

6. Check Traefik and make sure the project is available at `covid.whitney.rip`.

If mysql fails to start due to `Another process with pid 30 is using unix socket file`, this might be because the socket file was locked and was not unlocked in a previous run. Remove the file `/data/covid19/mysql.sock.lock` and it should start up correctly.

### Minecraft

Olomana runs a Paper Minecraft server based off of `https://github.com/itzg/docker-minecraft-server`. All server config is done via env vars in the docker-compose. 

Metrics are emitted via `https://github.com/sladkoff/minecraft-prometheus-exporter` The repo was cloned and the project was built into a jar file, and copied into the plugins directory if it was there already. 

The plugin's hostname is overwritten to 0.0.0.0 to allow all traffic in the config file. Otherwise minecraft will show up as DOWN in Prometheus. This allows the plugin to listen to outside traffic (Prometheus). 

Commands to get logs from the container are documented in the github repo: `docker exec minecraft_2023_olomana mc_log` and `docker logs -f minecraft_2023_olomana`.

1. Start container with docker-compose: `docker-compose up -d`.

2. Copy all plugins to plugins directory. Double check that all env vars requested have been copied correctly into the `server.properties` file. Sometimes they seem not to be copied or a cached version of the file ends up there.

**Plugins**

SinglePlayerSleep: `https://www.spigotmc.org/resources/singleplayersleep.68139/`
DynMap: `https://www.spigotmc.org/resources/dynmap%C2%AE.274/`
NoEndermanGrief: `https://www.spigotmc.org/resources/no-enderman-grief2.71236/`

### NordVPN 

Uses the open source https://github.com/bubuntux/nordvpn to create a NordVPN container that other containers can route traffic through.

The following changes were made on top of that config:

```
volumes:
- /data/write/qb/appdata/config:/config
- /data/write/qb/downloads:/downloads
```

```
FIREWALL=Enable
```

The default port is 8080, but I am using port 8888 via the `WEBUI_PORT=8888` instead due to a port conflict with Traefik.

## Part 3: SMB (Samba) Server

Created a samba server on a large drive to use as a NAS. 

Followed `https://phoenixnap.com/kb/ubuntu-samba`.

When connecting on windows go to the network tab and search for the server, format is: 

`\\ipaddress`

