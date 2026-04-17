# Karakeep
An AI powered notes, bookmarks, everything knowledge base.

## Setup

### General 
1. (If not using checked in Dockerfile) Use the Dockerfile from Karakeep:
```
wget https://raw.githubusercontent.com/karakeep-app/karakeep/main/docker/docker-compose.yml
```

2. This is what I changed from their base Dockerfile to get a runnable container when you checkout the repo:
- Convert exposed ports to traefik labels for the main container.
- Introduce Traefik network + create karakeep network for the containers to talk on.
- Convert volumes to bind mounts on disk.
- Convert to using env files instead of manually providing env vars. For some reason the dockerfile mixes use of explicit vars and .env file. Weird

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

