# Photoprism

Self hosted image gallery for PWS. 

### Instructions

Copy `docker-compose.yml.blanked` --> `docker-compose.yml`.

Change the default admin credentials/site/etc. 
Note that PHOTOPRISM_SITE_URL has the https prefix while the traefik label does not.

Start with `docker-compose up -d`.

### Public and Private Instances

So you have to pay if you want user management, so a workaround is to host a public and private version of photoprism. Unfortunately that doesn't work too well with Traefik, so the workaround is to have 2 configs that use the same uri but we run one or the other based on what we want/when we need to upload.

So copy the blanked yml to docker-compose-public.yml and docker-compose-private.yml. 

Run them with `docker-compose -f docker-compose-public.yml up -d`
