# Whitney Grafana

## Instructions

### Files
Create/Fill in the following files in a `grafana` directory under this one using the templates.
- `grafana.ini`
- `prometheus.yml`

### Volumes
Make sure that in additionto mounting the 2 files above to their respective containers, grafana container has the following mount:
- `/pwspool/software/grafana:/var/lib/grafana`

Also make sure that the correct user has access to the folder on the host machine, sometimes grafana won't start up otherwise.

### Grafana Setup
To set up the data source in grafana to point to prometheus, you would refer to `http://prometheus:9090`.

## Notes
Some images are hosted on Imgur and linked to via url.

## References
https://grafana.com/docs/grafana/latest/setup-grafana/installation/docker/
