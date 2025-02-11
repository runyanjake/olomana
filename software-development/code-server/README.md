# Visual Studio

A self-hosted version of Visual Studio Code, as an online notebook.

## Instructions

### Volumes
Mount the persistant storage somewhere.
- `/pwspool/software/code-server/config:/config`

### Metadata
Re-roll hashed passwords.  
`./olomana.ini:/etc/grafana/grafana.ini`

## References
https://docs.linuxserver.io/images/docker-code-server/  
https://coder.com/docs/code-server/latest/install#docker  
https://hub.docker.com/r/linuxserver/code-server  
https://github.com/coder/code-server/blob/main/docs/FAQ.md#can-i-store-my-password-hashed

