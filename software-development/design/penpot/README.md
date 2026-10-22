# Penpot
Open source Figma.

## Setup

1. Temporarily enable registation via flags in `.env`:

```env 
PENPOT_FLAGS=enable-registration enable-login-with-password disable-email-verification enable-prepl-server
```

and comment out `PENPOT_REGISTRATION_ENABLED=false`

2. Create new user either through UI or through command line:

```bash 
docker exec -it penpot-penpot-backend-1 python3 manage.py create-profile
```

3. Then reinstate old flags:

```env 
PENPOT_FLAGS=enable-login-with-password
```

and reinstate `PENPOT_REGISTRATION_ENABLED`.

## Runbook

```bash
docker compose down && docker system prune -af && docker compose up -d && docker logs -f penpot-penpot-backend-1
```

