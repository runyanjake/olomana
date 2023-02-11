# NordVPN

Some containers go through a nordvpn container. 

Uses the open source `https://github.com/bubuntux/nordvpn` repo to create a NordVPN container that other containers can reference when starting up.

Changes were made to the docker-compose following each container's README instructions on the various repos.

```
Volumes:
- /data/persistent/qb/appdata/config:/config
- /data/persistent/qb/downloads:/downloads
```

```
FIREWALL=Enable
```

Note: If conflicts on qb port, can change it by setting the env var for WEBUI_PORT=xxxx.
