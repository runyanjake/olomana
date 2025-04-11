# Minecraft

Self-host one or multiple servers.

## Setup

### Whitelist

#### Method 1: Docker 
In the `itzg/minecraft-server` env vars in docker, add the following to enable and configure whitelist.
```
ENABLE_WHITELIST: "TRUE"
WHITELIST: "player1,player2,player3"
```
Note: The whitelist is additive, so if you set it to `[player1]` and later `[player2,player3]`, you'll end up with a whiltelist accepting all 3 players.

Edit the whitelist in `whitelist.json` in the server directory.

#### Method 2: Manual
After first time startup set `enforce-whitelist=true` in `server.properties`.

Then, create `whitelist.properties` in the server directory with the following contents:
```
[
  {
    "uuid": "player_uuid",
    "name": "player_username"
  }
]
```

#### Method 3: In Game 
After first time start go into `server.properties` and set `enforce-whitelist=true`.  
Add users via server commands (`whitelist add NAME`).  

#### Plugins/Mods

### Plugins
SinglePlayerSleep: `https://www.spigotmc.org/resources/singleplayersleep.68139/`  
Dynmap: `https://www.spigotmc.org/resources/dynmap%C2%AE.274/`  
NoEndermanGrief: `https://www.spigotmc.org/resources/no-enderman-grief2.71236/`  
ajLeaderboards: `https://www.spigotmc.org/threads/ajleaderboards.471179/`

#### Updating Plugins
It's very easy, just obtain the new jar file for the updated plugin, stop server and swap old jar in `plugins/`.

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

## References
https://github.com/itzg/docker-minecraft-server  
https://github.com/Joshi425/minecraft-exporter

