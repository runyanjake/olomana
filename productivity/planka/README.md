# Planka
Self hosted Kanban organizer.

## Setup

### General 
1. (If not using checked in Dockerfile) Use the Dockerfile from Planka:
```
curl -L https://raw.githubusercontent.com/plankanban/planka/master/docker-compose.yml -o ./docker-compose.yml
```

2. This is what I changed from their base Dockerfile to get a runnable container when you checkout the repo:
- Convert exposed ports to traefik labels for the main container.
- Introduce Traefik network + create planka network for the containers to talk on.
- Convert volumes to bind mounts on disk.
- Convert to using env files instead of manually providing env vars.

3. Create Env files 
Copy `planka.env.example` to `planka.env`, and `planka-db.env.example` to `planka-db.env` and fill with data, observing the following:
- Update `BASE_URL` to point to vanity URL. Optionally generate a `SECRET_KEY` as well.
- The `POSTGRES_DB` value in `planka-db.env` should match the database specified by `DATABASE_URL` in `planka.env`. 

4. Start just the db
```
docker compose up -d postgres
```

5. Create Admin User 
```
docker compose run --rm planka npm run db:create-admin-user
```

6. Start the rest of Dockerfile
```
docker compose up -d
```

