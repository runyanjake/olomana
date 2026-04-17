# Taiga
Open source Agile project management tool.

## Architecture
Traffic flows: **Traefik → taiga-gateway (nginx) → internal services**

- `taiga-gateway` — nginx reverse proxy; the only service on the Traefik network
- `taiga-back` — Django backend API
- `taiga-async` — Celery worker (same image as back, different entrypoint)
- `taiga-front` — Angular frontend
- `taiga-events` — WebSocket events service
- `taiga-protected` — Protected media token verification
- `taiga-db` — PostgreSQL
- `taiga-async-rabbitmq` — RabbitMQ for Celery async tasks
- `taiga-events-rabbitmq` — RabbitMQ for real-time WebSocket events

## Setup
1. Copy `.env.example` to `.env` and fill out all values. Use `openssl rand -base64 32` for key/password generation.
2. Start the stack: `docker compose up -d`
3. Create the admin user:
```
docker exec -it taiga-back python3 manage.py createsuperuser --username admin --email admin@example.com
```

## Runbook

**Start / stop**
```
docker compose up -d
docker compose down
```

**View logs**
```
docker compose logs -f                  # all services
docker compose logs -f taiga-back       # one service
```

**Restart a single service**
```
docker compose restart taiga-back
```

**Create or reset admin user**
```
docker exec -it taiga-back python3 manage.py createsuperuser
```

**Update images**
```
docker compose pull
docker compose up -d
```

**Database backup / restore**
```
docker exec taiga-db pg_dump -U taiga_user taiga > backup.sql
docker exec -i taiga-db psql -U taiga_user taiga < backup.sql
```

## Notes
- Two separate RabbitMQ instances are required: one for Celery async tasks, one for WebSocket events.
- `EMAIL_USE_TLS` and `EMAIL_USE_SSL` are mutually exclusive — only set one to `True`.
- `EMAIL_BACKEND=console` logs emails to stdout (useful for testing). Switch to `smtp` for real email.
- Static files are stored in the `taiga-static` named Docker volume and shared between `taiga-back`, `taiga-async`, and `taiga-gateway`.
