# Docmost

[Docmost](https://docmost.com/) is an open-source collaborative documentation and wiki software.

Accessible at **https://documentation.whitney.rip**.

## Setup

1. Copy the example env file and fill in real values:

   ```bash
   cp .env.example .env
   ```

2. Generate secrets:

   ```bash
   # App secret (32+ characters)
   openssl rand -hex 32

   # Postgres password
   openssl rand -hex 16
   ```

3. Start the stack:

   ```bash
   docker compose up -d
   ```


## Health Check

```
https://documentation.whitney.rip/api/health
```

## Creating Users
Cannot be created manually, have to do manually via db insert.
1. Exec to container
```bash
docker exec -it docmost-db-1 psql -U docmost -d docmost
```
2. Obtain WORKSPACE_ID from the users table. 
Generate random password
```bash
select workspace_id from users;
```
3. Exit psql and generate random passord.
```
docker exec docmost-docmost-1 node -e "console.log(require('bcrypt').hashSync('REPLACE_PASSWORD', 12))"
```
3. Insert
```bash
INSERT INTO users (name, email, password, role, workspace_id, email_verified_at) VALUES ('Jake', 'jake@runyan.dev', '$2b$10$BEiObFC7osNTuY9GcQvV6eCU6vHKQjwohrr/uPPBFzlO27jLvQCHy', 'admin', '019d9dbf-daf5-7652-90d6-33ee72c883a1', now());
```
