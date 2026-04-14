# Plane

[Plane](https://plane.so) is an open-source project management tool — issues,
cycles (sprints), modules, pages, and views. Think of it as a self-hosted
alternative to Jira / Linear / Asana.

- Website: <https://plane.so>
- Source: <https://github.com/makeplane/plane>
- Docs: <https://docs.plane.so>
- Self-hosting reference: <https://developers.plane.so/self-hosting/overview>

This stack runs the community edition behind Traefik at
<https://plane.whitney.rip>.

## Architecture

The upstream release ships a bundled `plane-proxy` (Caddy) that routes
subpaths to the right internal service. We keep that proxy in place and only
expose **it** to the external `traefik` network — Traefik terminates TLS and
forwards to `plane-proxy:80`, which fans out inside the `plane` bridge
network:

| Path          | Service         | What it is                                  |
|---------------|-----------------|---------------------------------------------|
| `/`           | `web`           | Main Next.js application                    |
| `/spaces/*`   | `space`         | Public-shared views (read-only share links) |
| `/god-mode/*` | `admin`         | Instance admin UI (see below)               |
| `/live/*`     | `live`          | Real-time collaboration server              |
| `/api/*`      | `api`           | Django/DRF backend                          |
| `/auth/*`     | `api`           | Auth endpoints                              |
| `/uploads/*`  | `plane-minio`   | Object storage (attachments, avatars)       |

Supporting services: Postgres (`plane-db`), Valkey (`plane-redis`), RabbitMQ
(`plane-mq`), MinIO (`plane-minio`), plus a Celery `worker` + `beat-worker`
and a one-shot `migrator`.

## The `/god-mode` admin page

Plane splits its UI across two Next.js apps:

- `web` serves the normal app at `/` — this is what end-users see.
- `admin` serves the **instance-admin UI** at `/god-mode`.

`/god-mode` is where you, the operator, configure the Plane instance itself:
initial superuser, SMTP, SSO/OAuth providers (Google, GitHub, GitLab, Gitea),
sign-up toggles, and license keys. It is **not** a workspace admin — each
workspace has its own settings accessible from within the `web` app.

On first launch, hit <https://plane.whitney.rip/god-mode> before anything
else to create the instance admin. If you forget and create a normal user
first, you can promote them later via `docker compose exec api python
manage.py shell`.

## First-time setup

1. **Copy the env template and fill it in.**

   ```bash
   cp .env.example .env
   $EDITOR .env
   ```

   At minimum, set:
   - `DOMAIN=plane.whitney.rip`
   - `SECRET_KEY` — generate with `openssl rand -hex 25`
   - `POSTGRES_PASSWORD`, `RABBITMQ_PASSWORD`
   - `MINIO_ROOT_USER`, `MINIO_ROOT_PASSWORD`

   `.env` is gitignored; only `.env.example` is committed.

2. **Ensure the external Traefik network exists.**

   ```bash
   docker network inspect traefik >/dev/null \
     || docker network create traefik
   ```

3. **Create the data directories.** All persistent state lives on the host
   under `/pwspool/software/plane/`:

   ```bash
   sudo mkdir -p /pwspool/software/plane/{db,redis,rabbitmq,minio,logs/{api,worker,beat}}
   ```

4. **Pull images and start the stack.**

   ```bash
   docker compose pull
   docker compose up -d
   ```

   The `migrator` and `plane-createbuckets` containers run once and exit —
   that is expected. Tail logs until things settle:

   ```bash
   docker compose logs -f api web proxy
   ```

5. **Create the instance admin.** Browse to
   <https://plane.whitney.rip/god-mode>, set your admin email/password,
   then configure auth providers and SMTP.

6. **Create your first workspace.** Visit
   <https://plane.whitney.rip>, sign in with the admin account, and create
   a workspace. Invite users from within the workspace settings.

## Normal use

```bash
# Start / stop
docker compose up -d
docker compose down                 # stop; data persists under /pwspool
docker compose restart api worker   # restart a subset

# Status & logs
docker compose ps
docker compose logs -f api
docker compose logs -f proxy

# Pull latest images for the pinned APP_RELEASE and re-up
docker compose pull && docker compose up -d

# Upgrade to a newer Plane release
# 1. Check https://github.com/makeplane/plane/releases
# 2. Bump APP_RELEASE in .env (e.g. v1.3.0 -> v1.4.0)
# 3. Pull + up — migrator re-runs automatically
docker compose pull && docker compose up -d

# Shell into a running service
docker compose exec api bash
docker compose exec plane-db psql -U "$POSTGRES_USER" "$POSTGRES_DB"

# Run a Django management command
docker compose exec api python manage.py shell
docker compose exec api python manage.py reset_password <email>
```

## Data layout

```
/pwspool/software/plane/
├── db/          # Postgres PGDATA
├── redis/       # Valkey persistence
├── rabbitmq/    # RabbitMQ mnesia
├── minio/       # MinIO object store (uploads bucket)
└── logs/
    ├── api/
    ├── worker/
    └── beat/
```

For backups, at minimum capture:
- `pg_dump` of the `plane` database (cleaner than tar'ing `db/`)
- `minio/` (attachments, avatars)

## Notes & gotchas

- **Password strength is hardcoded.** Plane requires a zxcvbn score of 3
  (strong) plus 8-character minimum. There is no env var to relax this —
  use a passphrase or a password manager.
- **`plane-proxy` is Caddy**, not nginx (despite the historical
  `NGINX_BASE_DOMAIN` variable in older docs). It needs `SITE_ADDRESS`,
  `BUCKET_NAME`, and `FILE_SIZE_LIMIT`. In our setup Caddy listens on plain
  HTTP :80 and Traefik terminates TLS in front.
- **`certresolver=lets-encrypt`** in the Traefik labels matches the
  convention used by the sibling stacks (`taiga`, `planka`). Adjust if your
  Traefik uses a different resolver name.
- **Uploads live in MinIO** inside the stack (`USE_MINIO=1`). To use
  external S3, flip `USE_MINIO` to `0` in `docker-compose.yml`'s
  `x-backend-env` block and override the `AWS_*` vars.
- Upstream docker-compose / variables files are published per release at
  <https://github.com/makeplane/plane/releases/latest> — useful as a
  reference when new knobs appear.
