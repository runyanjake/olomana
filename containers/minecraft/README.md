# Whitney Minecraft

PWS hosts Minecraft servers. Based off `https://github.com/itzg/docker-minecraft-server` for 1.17+ as `https://github.com/nimmis/docker-spigot` is no longer maintained past 2019.

All server configuration done with env vars.
Data stored on disk rather than docker volume so things like the config can be edited via just ssh.

Minecraft emits metrics for Prometheus to collect for Grafana. We are exporting metrics via the docker container described in `https://github.com/Joshi425/minecraft-exporter`. Change the default port via env variable to make sure there aren't port conflicts. 

Monitoring commands to get logs from the minecraft container are documented in the github repo.

example: `docker exec minecraft_2023 mc_log`

### Build all components with Docker Compose

`docker-compose up -d`

### Start with Plain Docker

`docker run -d -p 25565:25565 --network=host --restart=always --name=minecraft_2023 -e EULA=true -e MC_MAXMEM=2g -e MC_MINMEM=512m -v /data/minecraft_1.16:/minecraft nimmis/spigot`
`docker run -d -p 25565:25565 --restart=always -e TYPE=SPIGOT --name=minecraft_creative -e EULA=TRUE -v /data/minecraft_1.17:/data -v ./server.properties:/data/server.properties itzg/minecraft-server`

##### Additional Setup

Make sure to go into server.properties and set

`white-list=true`.

Add users to whitelist via server commands or by creating whitelist.json in server directory.

```
[
  {
    "uuid": "player_uuid",
    "name": "player_username"
  }
]
```

Don't get griefed! We did once! :)

##### Plugins

SinglePlayerSleep: `https://www.spigotmc.org/resources/singleplayersleep.68139/`

Dynmap: `https://www.spigotmc.org/resources/dynmap%C2%AE.274/`

NoEndermanGrief: `https://www.spigotmc.org/resources/no-enderman-grief2.71236/`

ajLeaderboards: `https://www.spigotmc.org/threads/ajleaderboards.471179/`

##### Periodic Restarts

The minecraft server runs into instability from time to time. Thus, it needs to be restarted every once and a while.

Since people play late, I chose to update at 2am PST.

`sudo crontab -e`

add `0 2 * * * docker restart minecraft-2023 minecraft-creative`

