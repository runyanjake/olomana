# Leantime
Open source goals-focused project management system.

## Setup
1. Copy `.env.example` to `.env` and fill out all values. Use `openssl rand -base64 32` for `LEAN_SESSION_PASSWORD` and DB passwords.
2. Start the stack: `docker compose up -d`
3. Open `https://${DOMAIN}/install` once to run the first-time installer; it will create the schema and the initial admin user.

## Runbook

Single Command
```bash
docker compose down && docker system prune && docker compose up -d && docker logs -f leantime
```

**Fix data folder permissions (run on first boot / when adding a new host volume)**
The PHP container runs as `www-data` (UID/GID 1000) and needs to own everything except `db/` (MySQL manages its own).
```
sudo chown -R 1000:1000 /pwspool/software/leantime/{public_userfiles,userfiles,plugins,logs}
```

