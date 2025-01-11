# Immich
Self hosted photography server.

## Setup
1. Setup is easy. Follow `https://immich.app/docs/install/docker-compose` to download the `dockerfile` and `.env` config files.
2. Add custom values to `.env` where applicable (data/upload locations, and set custom DB pw)
3. Customize the dockerfile for Traefik things.
3a. Networks, add traefik network and make a new immach bridge network so things can continue to communicate after you add traefik. Make sure all containers use it.  
3b. Traefik tags, add the default ones.

## Dealing with Traefik Timeouts
By default there are 60s upload, download, and idle timeouts in Traefik. Adjust them by modifying `traefik.toml`:
```
[entryPoints.websecure.transport.respondingTimeouts]
    readTimeout = "512s"
    writeTimeout = "512s"
    idleTimeout = "512s"
``` 
