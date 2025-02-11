# Traefik

Traefik is my load balancer.
`https://doc.traefik.io/traefik/getting-started/quick-start/`

## Setup

### Files
Create/Fill in the following files in a `traefik/` directory under this one using the provided templates:
- `traefik.toml`
- `traefik-dynamic.toml`.

The file `traefik/acme.json` will be generated on first run. Make sure it eventually gets permission code 600. You might need to create a blank file before the first run.

### Volumes
In addition to the above files, make sure the docker socket is mounted:
- `/var/run/docker.sock:/var/run/docker.sock:ro`

## Reminders
The file `acme.json` can be weird when it comes to permissions. It will be generated on first run.  
Ensure it is permission code 600.

## Adjustments
By default there are 60s upload, download, and idle timeouts. Adjust them by modifying `traefik.toml`:
```
[entryPoints.websecure.transport.respondingTimeouts]
    readTimeout = "512s"
    writeTimeout = "512s"
    idleTimeout = "512s"
```

## References
https://doc.traefik.io/traefik/getting-started/quick-start/  
https://doc.traefik.io/traefik/user-guides/docker compose/basic-example/
