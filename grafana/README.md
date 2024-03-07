# Whitney Grafana

Resource: https://grafana.com/docs/grafana/latest/setup-grafana/installation/docker/

Note: Create a `grafana` user and add its UID to the docker-compose file so that created files will be given the correct ownership for later. Then, when running the container for the first time, use sudo so we can create the folder hierarchy for grafana.

Grafana instance that produces system metrics. Creates a Node-Exporter container that reads system metrics. A bridge network is created to allow Prometheus to query Node Exporter for metrics. Grafana connects to Prometheus via its bridge network to gather aggregated metrics.
</br>
Custom configuration held in grafana.ini in the container. Container expects to copy in a file called "olomana.ini", which is not checked into git.
</br>
After starting this image, we still need to create a datasource. Select Prometheus as the type, and `prometheus_whitney:9090` is the address. Everything else can be default. The networks need to be set up correctly to be able to refer to the container like this. If not, specifying it over the local network works fine.
</br>
We also need to create a dashboard if starting from scratch. A good default one for node-exporter is `1860`.

Setting up the data source is kind of dumb. you need to both indicate you want to communicate over http and to the container by name. So the correct thing to put when making a prometheus data source is `http://prometheus:9090` if the container name is "prometheus".

You can check the contents of Prometheus with `curl localhost:9090/metrics`.

The repo contains `grafana.ini`, the config file for grafana. By default this defines the admin account to be `admin:admin`. Change that and save the new file as `olomana.ini`, which is what will be copied into the container.

### Start with Docker-Compose (USING SUDO, see ownership issues above.)

`sudo docker-compose up -d`

I usually had to manually give ownership to the right user to the /pwspool/grafana folder hierarchy before grafana would work.

Also, if using traefik, to expose this container, you probably need to restart traefik after this container goes up.

#### Customization Notes
Images can be hosted by imgur and added in html to a Text Panel.

