# Traefik

I got recommended Traefik over Nginx for its ease of use and service discovery.

For setup I followed this official Traefik tutorial: https://doc.traefik.io/traefik/getting-started/quick-start/

`https://doc.traefik.io/traefik/user-guides/docker-compose/basic-example/` is also a good reference.

GENERAL NOTE: Don't restart the container that often because it issues Let'sEncrypt challenges that can get you rate limited quickly. (1hr cooldown)

## GENERAL REMINDERS

There is some funkiness with Traefik's acme.json file. The container is supposed to create it and manage it but due to docker linking of files and folders this gets mixed up.

Reading the logs can help you understand, need to look backward from the cert resolver that i've called lets-encrypt.

To make Traefik correctly populate the acme.json do the following:

1. create acme.json yourself.

2. Make sure the mount in docker works with the definition of the certresolver in traefik.toml.

I found that we needed to have a full path (or at least a path that contained a folder, so that traefik didn't get confused and think that acme.json was a folder.

3. Give the acme.json file specific permissions (600) e.g. `chmod 600 acme.json`

4. Run docker-compose, does not require you to be root.


### Baby Steps Setup

##### Step 1

1. Run `step1-docker-compose.yml`

`docker-compose -f step1-docker-compose.yml up -d`

2. Test by curl

`curl http://localhost:8080/api/rawdata`

3. Stop all and prune

`docker stop step1-traefik`

`docker system prune`

##### Step 2

1. Run `step2-docker-compose.yml`

`docker-compose -f step2-docker-compose.yml up -d`

2. Test by curl

`curl -H Host:whoami.docker.localhost http://127.0.0.1`

3. Stop all and prune

`docker stop step2-traefik step2-whoami`

`docker system prune`

##### Step 3

1. Run `step3-docker-compose.yml`

`docker-compose -f step3-docker-compose.yml up -d`

2. Test by curl

`curl http://whoami.whitney.rip`

3. Stop all and prune

`docker stop step3-traefik step3-whoami`

`docker system prune`

### Actual Traefik Setup

##### Step 1: Basic Traefik

Starting with the basic example: `https://doc.traefik.io/traefik/user-guides/docker-compose/basic-example/`

1. Change basic things like names of containers, routing host for the example service.

2. Add a traefik-specific network for the containers to communicate over. Other containers outside of this config file can reference it so that Traefik can discover and send requests to them internally.

3. Run, and test that the whoami container gives its response back correctly.

4. Then, configure other containers to be discovered off of Traefik by adding the basic labels: `traefik.enable`, `traefik.http.routers.container_name.rule`, and `traefik.http.routers.container_name.entrypoints`. 


##### Step 2: Proper Traefik Config

1. Convert the traefik related command line flags into traefik static and dynamic config. I am using toml files. These are `step5-traefik.toml` and `step5-traefik-dynamic.toml`. The static should reference a folder that the dynamic is copied into in the docker-compose.

Note: These pages are good examples of syntax and options. `https://doc.traefik.io/traefik/reference/static-configuration/file/` and `https://doc.traefik.io/traefik/reference/dynamic-configuration/file/`

Note: The Dynamic config is empty, and this is for good reason. See `https://doc.traefik.io/traefik/routing/providers/docker/` 

`If a label defines a router (e.g. through a router Rule) and a label defines a service (e.g. implicitly through a loadbalancer server port value), but the router does not specify any service, then that service is automatically assigned to the router.`

Because we define the router as labels in docker-compose, we don't have to define them in the dynamic conf, which is where we'd normally have to do it.

From this point, when we add another service, all that has to be done is the following:

> 1. Add the `traefik_traefik-network` as an external network, so that the container can communicate with Traefik internally.

> 2. Add the external network to the container's definition.

> 3. Add labels defining a router for this container. This should at least include the `traefik.enable`, `traefik.http.routers.my_router_name.rule`, and `traefik.http.routers.my_router_name.entrypoints` labels.


### Some old notes from when I tried TLS stuff.

Followed this tutorial: `https://doc.traefik.io/traefik/user-guides/docker-compose/acme-dns/`.

Providers list for Traefik: `https://doc.traefik.io/traefik/https/acme/#providers`.

1. Update `docker-compose-BLANKED.yml` with the correct values and copy it to `docker-compose.yml`.

`EMAIL@ME.COM`

`CLOUDFLARE@EMAIL.COM`

`API_KEY`

`MYDOMAIN.COM`

2. Run `docker-compose.yml`

`docker-compose up -d`

3. Test by curl, then on browser.

`curl -vvv https://whitney.rip`

If certificate is not right, can probably debug from the curl response.

Try `https://whitney.rip` in browser, should see the curl response in html.

BEFORE running the container, create acme.json with permission code 600. Otherwise the container will create a folder instead.

Running the container will generate the following structure:

`letsencrypt/`

|--> `acme.json`

4. Check that the api is working.

Visit `http://YOUR_IP_HERE:8080/dashboard`

### Additional Steps

1. Convert to a static Traefik configuration (seems better)

Create `traefik.toml` and edit the `docker-compose.yml` to ensure that it's copied to one of the searched directories (I chose `/etc/traefik/`)

The conversion from env vars to `traefik.toml` is really easy - each one of them is basically describing one attribute of the yaml, so basically just build the yaml from those attributes.

2. Start to secure the Traefik Dashboard.

Generate a password with `htpasswd` (`https://doc.traefik.io/traefik/middlewares/http/basicauth/`)

Example using BCrypt: `https://unix.stackexchange.com/questions/307994/compute-bcrypt-hash-from-command-line`. See this thread about Traefik not liking the `$` character: `https://github.com/DeviaVir/zenbot/issues/2663`



# Some notes about making this a cleaner experience.

I have created blanked files for the traefik.toml and traefik-dynamic.toml since they need important info that will vary by deployment. 

When putting in the user and pw to the toml, you generate the password with htpasswd, but that generates a string with escaped dollar sign values. Since we're putting it into the toml we can replace the double dollar signs with just single dollar signs. 

Also. the acme.json is generated by letsencrypt, so that is not included in the repo as it's a secret. 

