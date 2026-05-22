# OpenProject
Open source project management software.

# Setup
1. Configure `.env`, see example.
  - Note to specify `OPENPROJECT_HOST__NAME` without protocol.
2. Bring the stack up: `docker compose up -d`.
3. First-time login: `admin` / `admin`. You'll be forced to set a new password on first sign-in.
  - To pre-seed the admin password and skip the forced reset, set before first boot:
    - `OPENPROJECT_SEED_ADMIN_USER_PASSWORD=<strong password>`
    - `OPENPROJECT_SEED_ADMIN_USER_PASSWORD_RESET=false`

# Toggling self-signup
Controlled by `OPENPROJECT_SELF__REGISTRATION` (double underscore is intentional):
- `0` — disabled
- `1` — email activation
- `2` — manual admin activation
- `3` — automatic activation

The env value seeds the setting; an admin can still change it via Administration → Authentication → Settings.

# Wiping persistent data
The all-in-one image bundles Postgres inside the container. The bind mount at `/pwspool/software/openproject` holds both `pgdata/` (database) and `assets/` (uploaded files). To start fresh:
```
docker compose down
sudo rm -rf /pwspool/software/openproject/pgdata /pwspool/software/openproject/assets
docker compose up -d
```
