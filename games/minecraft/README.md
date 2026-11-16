# Minecraft
Manage your Minecraft server hosting via code, for a dockerized deployment. 

## Plugins

### Active Plugins (Last Updated 2026/11/15)
- [Bluemap](https://www.spigotmc.org/resources/bluemap.83557/) - Dynmap alternative providing web-accessible live-updating player map. We are using the Docker container, not the plugin.
- [sladkoff/Minecraft-Prometheus-Exporter](https://github.com/sladkoff/minecraft-prometheus-exporter/releases) - Prometheus node exporter for Minecraft servers.
- Instead of using Single Player Sleep, Spigot gamerules can be used instead: `/gamerule playersSleepingPercentage 1`.

### Plugin Configuration

#### PrometheusExporter
After starting the server, edit `/path/to/minecraft/directory/plugins/PrometheusExporter/config.yml`:
```text
host: 0.0.0.0
port: 9940
```

#### BlueMap
*Note that we are using the BlueMap docker container, not a plugin.*
After starting the server, go to the BlueMap containers' mounted directories and edit `/pwspool/games/minecraft/bluemap_container_name/config/core.conf` (if multiple instances, you have to do multiple times):
```text
accept-download: true
render-thread-count: 2  # or some reasonable number
```
Additionally, you will need to edit `nvim /pwspool/games/minecraft/bluemap_2023/config/maps/overworld.conf`:
```text
world: "/app/world/world"
name: "YOUR_WORLD_NAME"
```
**Starting a Render**:
```text
docker exec -it bluemap_2023 java -jar cli.jar -r
```

### Updating Plugins
Most should be forward compatible, just drop the new `.jar` file in `/path/to/server/files/plugins/` and restart.

### Old Plugins 
- SinglePlayerSleep/OnePlayerSleep+ ([1](https://www.spigotmc.org/resources/singleplayersleep.68139/)) ([2](https://modrinth.com/plugin/oneplayersleepgg?version=1.21.11&loader=paper)) - Replaced by Spigot gamerule `/gamerule playersSleepingPercentage 1` to get the desired effect.
- Dynmap ([1](https://www.spigotmc.org/resources/dynmap%C2%AE.274/)) ([2](https://www.curseforge.com/minecraft/bukkit-plugins/dynmap/files/7460127))
- NoEndermanGrief ([1](https://www.spigotmc.org/resources/no-enderman-grief2.71236/)) ([2](https://modrinth.com/plugin/no-enderman-griefing/version/1.0))
- ajLeaderboards ([1](https://www.spigotmc.org/threads/ajleaderboards.471179/))

## General Configuration

### Whitelist (via Docker)
Add the following env vars in docker-compose.yml:
```bash
ENABLE_WHITELIST: "TRUE"
WHITELIST: "player1,player2,player3"
```
The whitelist will be created in `whitelist.json` in the server directory. Adding something there will update the whitelist on the next run

### Whitelist (Manually)
1. After first time startup set `enforce-whitelist=true` in `server.properties`.
2. Then, create `whitelist.properties` in the server directory with the following contents:
```bash
[
  {
    "uuid": "player_uuid",
    "name": "player_username"
  }
]
```

#### Option 3: Via In-Game Commands 
After first time start go into `server.properties` and set `enforce-whitelist=true`.  
Add users via server commands (`whitelist add NAME`).

### Periodic Restarts
You might want this because the JVM might start hitting memory limits if too much is going on. 

You can configure scheduled restarts by configuring `crontab` to periodically restart the container.  
Edit crontab: `sudo crontab -e`
Add: `0 2 * * * docker restart minecraft-2023 minecraft-creative`

## Runbook
Recreate All:
```text
docker compose up -d --force-recreate
```
Start a BlueMap Scan:
```text
docker exec -it bluemap_2023 java -jar cli.jar -r
```
Create Tar archive:
```text
cd location_of_mc_files
tar -czvf ~/1970.01.01-world-backup.tar.gz world world_nether world_the_end server.properties whitelist.json spigot.yml
```

## References
https://github.com/itzg/docker-minecraft-server  
https://github.com/Joshi425/minecraft-exporter

