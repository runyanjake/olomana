# Monica

Reference: https://hub.docker.com/_/monica

### Installation

Using the default dockerfile provided, change the following 

- ports - default port will collide with traefik. Use something like 8022.

- APP_KEY - generated with `echo -n 'base64:'; openssl rand -base64 32` like they suggest.

- env vars - change default user/pw

- Add traefik tags.

Run everything & follow instructions.
