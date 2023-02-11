# Whitney Minecraft

PWS hosts Minecraft servers. Based off `https://github.com/itzg/docker-minecraft-server` for 1.17+ as `https://github.com/nimmis/docker-spigot` is no longer maintained past 2019.

All server configuration done with env vars.
Data stored on disk rather than docker volume so things like the config can be edited via just ssh.

Minecraft emits metrics for prometheus to collect via `https://github.com/sladkoff/minecraft-prometheus-exporter`. Clone the repo & build the project into a jar and copy it into the `/plugins` directory for minecraft. 
Take special care to overwrite the plugin's default "hostname" to `0.0.0.0` to allow all traffic in the config file. Otherwise the minecraft target will show up as DOWN in Prometheus. This allows the plugin to listen to traffic from outside the container (namely the prometheus instance). 

Monitoring commands to get logs from the container are documented in the github repo.

example: `docker exec minecraft_2023 mc_log`

### Build all components with Docker Compose

`docker-compose up -d`

### Start with Plain Docker

`docker run -d -p 25565:25565 --network=host --restart=always --name=minecraft_2023 -e EULA=true -e MC_MAXMEM=2g -e MC_MINMEM=512m -v /data/minecraft_1.16:/minecraft nimmis/spigot`
`docker run -d -p 25565:25565 --restart=always -e TYPE=SPIGOT --name=minecraft_creative -e EULA=TRUE -v /data/minecraft_1.17:/data -v ./server.properties:/data/server.properties itzg/minecraft-server`

##### Plugins

Metrics: `https://github.com/sladkoff/minecraft-prometheus-exporter` as described above. Build jar and copy to jars folder. Ensure hostname is set to 0.0.0.0 to allow for remote pings.

SinglePlayerSleep: `https://www.spigotmc.org/resources/singleplayersleep.68139/`

Dynmap: `https://www.spigotmc.org/resources/dynmap%C2%AE.274/`

NoEndermanGrief: `https://www.spigotmc.org/resources/no-enderman-grief2.71236/`

ajLeaderboards: `https://www.spigotmc.org/threads/ajleaderboards.471179/`


