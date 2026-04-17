# Traefik

Traefik is my load balancer.
`https://doc.traefik.io/traefik/getting-started/quick-start/`

## Setup

### Folder Structure
Create/Fill in the following files in a `traefik/` directory under this one using the provided templates:
- `traefik.toml`
- `traefik-dynamic.toml`.

Before the first run, create `acme.json` with the initial contents `{}`. Make sure it has permission code 600 (`chmod 600 acme.json`), incorrect permissions will break traefik.

### Volumes
In addition to the above files, make sure the docker socket is mounted:
- `/var/run/docker.sock:/var/run/docker.sock:ro`

## Notes

### Adjustments
By default there are 60s upload, download, and idle timeouts. Adjust them by modifying `traefik.toml`:
```yaml
[entryPoints.websecure.transport.respondingTimeouts]
    readTimeout = "512s"
    writeTimeout = "512s"
    idleTimeout = "512s"
```

### References
https://doc.traefik.io/traefik/getting-started/quick-start/  
https://doc.traefik.io/traefik/user-guides/docker compose/basic-example/

## Runbook
```bash
docker compose down && docker system prune && docker compose up -d && docker logs -f traefik
```


