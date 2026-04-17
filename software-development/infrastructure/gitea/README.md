# Gitea

Self-hosted git server backed by PostgreSQL, proxied through Traefik.

## Services

| Service | Image | Purpose |
|---------|-------|---------|
| `server` | `gitea/gitea:latest` | Gitea web/git server |
| `database` | `postgres:14` | PostgreSQL database |

Data is persisted to `/pwspool/software/gitea/` on the host.

## Setup

### 1. Configure environment

Copy the example env files and fill in values:

```
cp gitea.env.example gitea.env
cp database.env.example database.env
```

- `gitea.env` — Gitea app config (domain, SSH settings, DB credentials, etc.)
- `database.env` — PostgreSQL credentials

See the [Gitea config cheat sheet](https://docs.gitea.com/administration/config-cheat-sheet) for all available options.

### 2. Start the stack

```
docker compose up -d
```

### 3. Complete initial setup

Navigate to `https://git.whitney.rip` and complete the web installer. Values should match what's in `gitea.env`. A few known quirks:
- PostgreSQL must use the default port (5432); other ports may fail.
- Use `database` as the database hostname (matches the service name in `docker-compose.yml`).
- The first admin account can be created during initial setup or by enabling registrations temporarily via `GITEA__service__DISABLE_REGISTRATION=false`.

### 4. Provision users

From the admin account: **Site Administration > User Accounts > Create User Account**.

### 5. Configure SSH

SSH is exposed via Traefik TCP passthrough on port 2222:
- The `gitea` entrypoint on `:2222` is defined in `traefik.toml`.
- TCP router labels in `docker-compose.yml` forward `2222` → container port `2222`.
- `SSH_DOMAIN` and `SSH_PORT=2222` in `gitea.env` tell Gitea what to advertise in clone URLs.

Test SSH:
```
ssh -T -p 2222 git@git.whitney.rip
```

### 6. Add SSH keys for users

**Settings > SSH/GPG Keys > Manage SSH Keys** — same flow as GitHub.

## Running

```
docker compose down && docker compose build && docker compose up -d && docker logs -f gitea
```
