# Gitea
Self hosted Git  
Followed instructions on Gitea page: https://docs.gitea.com/next/installation/install-with-docker

### Steps
1. Create a new user to own the gitea folder.
```
sudo groupadd gitea && sudo useradd giteauser && sudo usermod -a -G gitea giteauser && chown -r gitea:giteauser .
```
2. Configure Environment
Create `gitea.env` and `database.env` from the examples, replacing with relevant env values.

See [Gitea Documentation](https://docs.gitea.com/administration/config-cheat-sheet) for examples/types.

2. Run via Docker Compose
```

docker-compose up -d
```
3. Test postgresql
```
docker exec -it gitea_db bash
psql -h 127.0.0.1 -p 5432 -U olomana_readwrite -d gitea
```

4. Go to xxx.xxx.xx.xxx:3000 and fill out initial config. Everything should match up to default value.
Some things that were weird:
- could not use any port that wasnt default postgresql (5432)
- had to make sure to specify database container by the right name. Removed custom name and used just "database".
Note that the first admin is set via env vars, by generating the password hash. Alternatively create your users by setting the env var that controls signups.

5. Provision new users
You can do that from the "Site Administration" view from the first admin user.

6. Configure SSH

Via Traefik (TCP passthrough on port 2222):
- The `gitea` entrypoint on `:2222` is defined in `traefik.toml`.
- TCP router labels in `docker-compose.yml` forward port 2222 → container port 22.
- `SSH_DOMAIN` and `SSH_PORT=2222` in `gitea.env` tell Gitea what to advertise in clone URLs.

Test with:
```
ssh -T -p 2222 git@git.whitney.rip
```

7. Handle user authentication like you'd do on Github by generating new ssh keys and adding them to the SSH Keys section.
Settings > SSH/GPG Keys > Manage SSH Keys
Now should also be able to clone with SSH.

### Running
```
docker compose down && docker compose build && docker compose up -d && docker logs -f gitea
```

### References
`https://docs.gitea.com/next/administration/config-cheat-sheet`
