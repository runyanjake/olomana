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

## Adding a Website

Each website is a container on the `traefik` network exposed via Traefik labels. Copy the block below into the service's `docker-compose.yml` and replace `myapp`, the host(s), and the port.

**Important:** the cert resolver is named `lets-encrypt` (with a hyphen) in `traefik.toml`. The label value must match it **exactly**. A mismatch like `letsencrypt` makes Traefik fall back to a self-signed `TRAEFIK DEFAULT CERT`, which browsers flag as "Not Secure".

```yaml
services:
  myapp:
    image: myimage:latest
    restart: unless-stopped
    networks:
      - traefik
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.myapp.rule=Host(`myapp.whitney.rip`)"
      - "traefik.http.routers.myapp.entrypoints=websecure"
      - "traefik.http.routers.myapp.tls.certresolver=lets-encrypt"
      - "traefik.http.services.myapp.loadbalancer.server.port=3000"

networks:
  traefik:
    external: true
```

HTTP-to-HTTPS redirection is handled globally by the `web` entrypoint, so you only need the `websecure` entrypoint here.

### Covering `www` (or multiple hostnames)

Traefik only serves a real cert for hostnames named in the router rule — anything else gets the self-signed default cert. To cover the apex **and** `www` on a single certificate, match both hosts and declare the SAN:

```yaml
      - "traefik.http.routers.myapp.rule=Host(`myapp.com`) || Host(`www.myapp.com`)"
      - "traefik.http.routers.myapp.entrypoints=websecure"
      - "traefik.http.routers.myapp.tls.certresolver=lets-encrypt"
      - "traefik.http.routers.myapp.tls.domains[0].main=myapp.com"
      - "traefik.http.routers.myapp.tls.domains[0].sans=www.myapp.com"
```

To force a single canonical URL, redirect `www` to the apex (note the `$$` — Compose needs it to pass a literal `$` to Traefik):

```yaml
      - "traefik.http.routers.myapp.middlewares=myapp-www"
      - "traefik.http.middlewares.myapp-www.redirectregex.regex=^https://www\\.(.*)"
      - "traefik.http.middlewares.myapp-www.redirectregex.replacement=https://$${1}"
      - "traefik.http.middlewares.myapp-www.redirectregex.permanent=true"
```

**DNS / Cloudflare:** every hostname in the rule must have a DNS record pointing at this server and must **not** be proxied through Cloudflare (orange cloud) — the TLS challenge has to reach Traefik directly, or issuance fails and the account can get rate-limited/paused. To keep the Cloudflare proxy on, switch that domain to the DNS-01 challenge instead.

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


