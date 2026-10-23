# Multica
Open source project management with coding agents. Runs the official `ghcr.io/multica-ai/multica-backend` and `multica-web` images, plus Postgres (pgvector). Agents run on this host through the `multica` CLI daemon.

## Layout
| Service | Networks | Exposed |
| --- | --- | --- |
| postgres | `internal` | — |
| backend | `internal`, `traefik` | traefik: `/ws` on `FRONTEND_HOST`; host: `127.0.0.1:8090` (daemon) |
| frontend | `internal`, `traefik` | traefik: everything else on `FRONTEND_HOST` |

- `internal` is a plain bridge for service-to-service traffic and outbound egress (email).
- Single domain. Next.js proxies `/api`, `/auth`, `/uploads`, `/v1` to the backend. It does not proxy websockets, so traefik sends `/ws` to the backend directly.
- No separate API domain. That layout requires `COOKIE_DOMAIN`, otherwise every write fails CSRF (403).
- The backend entrypoint runs DB migrations on every start.

## Setup
1. `cp .env.example .env` and fill it in.
   - `JWT_SECRET`: `openssl rand -hex 32`
   - `POSTGRES_PASSWORD`: `openssl rand -hex 24`. Must be URL-safe; base64 (`/`, `+`) breaks `DATABASE_URL` with "invalid port".
   - `MULTICA_VCS_SECRET_KEY`: `openssl rand -base64 32`
2. Point DNS for `FRONTEND_HOST` at traefik.
3. `docker compose up -d`
4. Sign in with email. The code is sent via Resend/SMTP, or printed in `docker logs multica-backend-1` if email isn't working.
5. After creating your workspace, optionally set `DISABLE_WORKSPACE_CREATION=true` and/or `ALLOW_SIGNUP=false`, then `docker compose up -d`.

## Versioning
Server images and the CLI are released together and must run the same version. The tag is pinned in `docker-compose.yml` (currently `v0.6.5`), not in `.env`. Do not use `:latest`: a `docker compose pull` would move the server without the CLI.

## Local agent daemon
Runs as the `multica` service user (system UID, home `/var/lib/multica`, no password, not in `docker`) under its systemd user unit. Connects to the backend on `127.0.0.1:${BACKEND_HOST_PORT}` (8090; 8080 belongs to traefik). The public domain does not resolve back to this host (hairpin NAT returns the router's self-signed cert), so use localhost.

The home directory is required: it holds `~/.multica` (config, token, logs), `~/.claude` (Claude Code login), `~/.config/systemd/user` (autostart unit), `~/multica_workspaces` (task checkouts) and `~/.local/bin` (CLIs).

Create the user:
```bash
sudo useradd --system --user-group --create-home --home-dir /var/lib/multica --shell /bin/bash multica
sudo loginctl enable-linger multica   # user systemd manager at boot, no login needed
```

Shell as `multica` with a systemd user session (used by every command below and in Upgrade):
```bash
sudo -iu multica env XDG_RUNTIME_DIR=/run/user/$(id -u multica) \
  DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u multica)/bus bash -l
```

Inside that shell:
```bash
export PATH="$HOME/.local/bin:$PATH"

# Claude Code (per-user install and login)
curl -fsSL https://claude.ai/install.sh | bash
claude                                # log in, then /exit

# multica CLI at the version pinned in docker-compose.yml
VER=0.6.5
cd "$(mktemp -d)"
curl -fsSLO "https://github.com/multica-ai/multica/releases/download/v${VER}/multica-cli-${VER}-linux-amd64.tar.gz"
curl -fsSLO "https://github.com/multica-ai/multica/releases/download/v${VER}/checksums.txt"
sha256sum --check --ignore-missing checksums.txt
tar -xzf "multica-cli-${VER}-linux-amd64.tar.gz" multica
install -m 755 multica ~/.local/bin/multica
cd ~

multica setup self-host --server-url http://localhost:8090 --app-url https://multica.whitney.rip
multica login --token=                # personal access token from Settings → Tokens in the web UI
multica daemon start
multica daemon status                 # expect: running, agent "claude", 1+ workspace
multica daemon autostart enable       # captures current PATH; ~/.local/bin must be on it
```
- Detects agent CLIs on `PATH` (`claude` here).
- The autostart unit only inherits `PATH`. Daemon settings go in `multica config set`. Other env vars agents need (e.g. `GH_TOKEN`) go in `/var/lib/multica/.config/environment.d/*.conf`.
- For agents that push code, give `multica` its own git identity and SSH key or token.
- Status from `jr`: `sudo -u multica XDG_RUNTIME_DIR=/run/user/$(id -u multica) systemctl --user status multica-daemon`. Logs: `multica daemon logs` as `multica`.
- Remove the user: `sudo loginctl disable-linger multica && sudo pkill -u multica && sudo userdel --remove multica`.
- Sign out of the CLI: `multica auth logout`. This only deletes the local token; revoke it in the web UI too.

## Upgrade
1. Change both image tags in `docker-compose.yml`.
2. `docker compose pull && docker compose up -d && docker logs -f multica-backend-1`
3. As `multica`, reinstall the CLI with the same `VER`, then `multica daemon stop && multica daemon start`.
4. Check that `multica version` matches the image tag.

## Risks
- **Agent access**: agents run as `multica`, which has no docker or sudo, but can still read anything world-readable on this host and reach localhost services (including the backend on 8090).
- **`RESEND_API_KEY`**: the current value doesn't look like a Resend key (those start with `re_`). Until it's fixed, login codes only appear in the backend logs.
- **No Redis**: auth endpoints have no rate limiting (logged at startup). Acceptable while signup is limited. Adding Redis also requires trusted-proxy settings (`RATE_LIMIT_TRUSTED_PROXIES`, `MULTICA_TRUSTED_PROXIES`) covering traefik and the frontend container, or all users share one rate-limit bucket.
- **Uploads on local disk** (`UPLOADS_DATA_DIR`): back it up along with `POSTGRES_DATA_DIR`.
- **Backend on the `traefik` network** (needed for `/ws`): other containers on that network can reach it directly.

## Possible extensions
- **Email via SMTP** instead of Resend: set the `SMTP_*` vars.
- **Google login**: `GOOGLE_CLIENT_ID`/`SECRET`. The redirect URI is `${FRONTEND_ORIGIN}/auth/callback`.
- **GitHub App** (PR cards, repo picker): `GITHUB_APP_SLUG`, `GITHUB_WEBHOOK_SECRET`, `GITHUB_APP_ID`, `GITHUB_APP_PRIVATE_KEY`. Add them to compose. Needs `MULTICA_PUBLIC_URL` reachable from GitHub.
- **Gitea/Forgejo integration**: already enabled (`MULTICA_VCS_*`). Connect it per workspace in Settings → Integrations.
- **S3 storage, Slack/Lark/Telegram bots, server-side LLM (chat titles), plugins**: env vars are documented in upstream `.env.example` and `docker-compose.selfhost.yml`. Add the ones you need to the backend `environment:`.
- **More agents**: install another supported CLI (`codex`, `opencode`, ...) on the host and restart the daemon.
