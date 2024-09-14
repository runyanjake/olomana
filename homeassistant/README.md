# Home Assistant
Home automation software.

## Installation

### Docker
1. Run the container to set up the local filesystem.
2. Modify the created config file, in `config/configuration.yaml` to allow the traefik proxy, or generally everything on the local network. NOTE: Traefik breaks homeassistant, needs to be over local network for now.
```
# Configure HTTP settings
http:
  use_x_forwarded_for: true
  trusted_proxies:
    - 192.168.96.0/24
```
Optionally, set the log level
```
# Configure logging
logger:
  default: debug
  logs:
    homeassistant.core: debug
    homeassistant.components: info
    homeassistant.components.mqtt: debug
```
Note these snippets should go above the `automation` line.  
`docker compose down && docker system prune -f && docker compose build && docker compose up -d && docker logs -f homeassistant`

### Home Assistant Setup
1. Set up devices/smart lights according to manufacturer instructions to get them on the local network.
2. Settings > Devices & Services > Add Integration
3. For my WiZ light, the automatic scan did not find it. I had to manually use nmap to find it on the network and enter the IP.
```
nmap -sn 192.168.1.xxx/24 (adjust for your local network)
```

## References
https://www.home-assistant.io/integrations/wiz/  

