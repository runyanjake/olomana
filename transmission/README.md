# Transmission

https://github.com/haugene/docker-transmission-openvpn

## Credentials

Username/pass from NordVPN is deprecated, now we go to `Services > NordVPN > Set up NordVPN manually` and use the service account credentials instead.

## Run With Docker
```
docker compose down && docker system prune -af && docker compose build && docker compose up -d && docker logs -f transmission
```

