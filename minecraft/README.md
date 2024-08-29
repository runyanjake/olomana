# Minecraft

Self-host one or multiple servers.

## Instructions

### Minecraft Setup

#### Whitelist
After first time start go into `server.properties` and set `white-list=true`.  
Add users via server commands (`whitelist add NAME`).  
OR add users to `whitelist.json` in server directory.  
```
[
  {
    "uuid": "player_uuid",
    "name": "player_username"
  }
]
```

#### Plugins/Mods

##### Plugins
SinglePlayerSleep: `https://www.spigotmc.org/resources/singleplayersleep.68139/`  
Dynmap: `https://www.spigotmc.org/resources/dynmap%C2%AE.274/`  
NoEndermanGrief: `https://www.spigotmc.org/resources/no-enderman-grief2.71236/`  
ajLeaderboards: `https://www.spigotmc.org/threads/ajleaderboards.471179/`

##### Mods

### Maintenance
Configure scheduled restarts by configuring `crontab` to periodically restart the container.  
Edit crontab: `sudo crontab -e`  
Add: `0 2 * * * docker restart minecraft-2023 minecraft-creative`

## References
https://github.com/itzg/docker-minecraft-server  
https://github.com/Joshi425/minecraft-exporter

