# Minecraft
Self-host one or multiple servers.

## Setup 

### Whitelist

#### Option 1: Via Docker
Add the following env vars in docker-compose.yml:
```bash
ENABLE_WHITELIST: "TRUE"
WHITELIST: "player1,player2,player3"
```
The whitelist will be created in `whitelist.json` in the server directory. Adding something there will update the whitelist on the next run.

#### Option 2: Manually
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

### Plugins/Mods

##### Plugins (Updated 3/29/2026)
[OnePlayerSleep+](https://modrinth.com/plugin/oneplayersleepgg?version=1.21.11&loader=paper)
[NoEndermanGrief](https://modrinth.com/plugin/no-enderman-griefing/version/1.0)

#### Plugins (Old)
SinglePlayerSleep: `https://www.spigotmc.org/resources/singleplayersleep.68139/`  
Dynmap: `https://www.spigotmc.org/resources/dynmap%C2%AE.274/`  
NoEndermanGrief: `https://www.spigotmc.org/resources/no-enderman-grief2.71236/`  
ajLeaderboards: `https://www.spigotmc.org/threads/ajleaderboards.471179/`

#### Updating Plugins
Obtain the new jar file for the updated plugin, stop server and swap old jar in `plugins/`.
Most plugins should not need to regenerate their data, so you can leave it as is. 

## Maintenance

### Backups
Take backups periodically, we got griefed once and only survived because of a backup.

Create Tar archive:
```
cd location_of_mc_files
tar -czvf ~/1970.01.01-world-backup.tar.gz world world_nether world_the_end server.properties whitelist.json spigot.yml
```
And move to a safe place.

### Periodic Restarts
You might want this because the JVM might start hitting memory limits if too much is going on. 

You can configure scheduled restarts by configuring `crontab` to periodically restart the container.  
Edit crontab: `sudo crontab -e`
Add: `0 2 * * * docker restart minecraft-2023 minecraft-creative`

## Runbook
Start all:
```bash
docker compose down && docker system prune -af && docker compose up -d && docker logs -f minecraft-2023 
```

Start single:
```bash
docker compose down && docker system prune -af && docker compose up -d minecraft_solo && docker logs -f minecraft_solo
```

## References
https://github.com/itzg/docker-minecraft-server  
https://github.com/Joshi425/minecraft-exporter

