# Covid 19 App

Covid 19 app from `https://github.com/KevRunAmok/Covid19app` & dockerized by me to build both the app and the dependancy mysql container.
>
Clone that repo and copy the relevant files into the same directory as docker-compose.yml before moving on.

*I'd highly recommend calling the image you create "kr/covidapp" insead of "kr/covid_whitney", that's an old name.*

A few inital setup steps need to be taken if building the container from scratch. (see below)

Also make sure that the `./schema` folder is created with sql to create the database and populate data.

Note: If mysql can't start due to `Another process with pid 30 is using unix socket file`, this is likely because the socket file was locked when the container was last shut down. It persists to `/data/covid19/mysql.sock.lock` so removing this should fix the issue.

### Build Image With Docker

`docker build --tag="kr/covidapp" .`

### Start with Docker-Compose

Creates the mysql container, the covid container, and a shared network they communicate on.

`docker-compose up -d`

### Start with Plain Docker (Just the Covid App)

Build the image with:

`docker build --tag="kr/covidapp" .`

Run the image with: 

`docker run -d --name="covidapp" --network=mysql-network --restart=always -p 1337:1337 kr/covidapp`

Note: this requires the mysql-network. If not created already create it with:

`docker network create mysql-network`

## Container Setup Steps

1. Run the container(s) with docker-compose. Watch logs for mysql and wait till it's ready to aaccept connections.
2. Create a user who can query the tables.
- `docker exec -it mysql_covidapp mysql -uroot -proot`
- `select * from mysql.user;`/`select Host, User from mysql.user;`
- `CREATE USER 'kr_covid'@'%' IDENTIFIED BY 'kr_covid';`
- `ALTER USER 'kr_covid'@'%' IDENTIFIED WITH mysql_native_password BY 'covid123';`
- `GRANT ALL ON sql_covid19.* to 'kr_covid'@'%';`
- After adding this user you can exec onto the container and run mysql from there.
3. Import any data. (Note this step must be done each time the databases is wiped - aka when the persistant folder /data/covid19/mysql is deleted.)
If you specified it in `./schema` it'll also be copied into `/docker-entrypoint-initdb.d/`

