# Gitea

Self hosted Git

Followed instructions on Gitea page: https://docs.gitea.com/next/installation/install-with-docker

### Steps
	
1. Create a new user to own the gitea folder.

`sudo groupadd gitea && sudo useradd giteauser && sudo usermod -a -G gitea giteauser && chown -r gitea:giteauser .`

2. Run via Docker Compose

`docker-compose up -d`

3. Test postgresql

`docker exec -it gitea_database bash`

`psql -h 127.0.0.1 -p 5432 -U gitea`

4. Stop server and set value in app.ini.

Add magic line to /data/persistent/gitea/gitea/gitea/conf/app.ini because local workers will otherwise assume they can use our custom port 3300 to reach services locally. Have to specify local url here.

This goes in the [server] section. (https://docs.gitea.com/next/administration/config-cheat-sheet)

`LOCAL_ROOT_URL = http://localhost:3000/`

Then start containers again.

5. Go to xxx.xxx.xx.xxx:3300 and fill out initial config.

Some things that were weird: 

- could not use any port that wasnt default postgresql (5432)

- had to make sure to specify database container by the right name. Removed custom name and used just "database".

6. Handle Authentication like you'd do on Github with SSH keys etc.

Settings > SSH/GPG Keys > Manage SSH Keys

