# Chat

# Implementations

## Deepseek Stack using Ollama & OpenWebUI

### Ollama (Manually)
Start a server by first 
```
ollama serve
```
(Default port is 11434). 
And then run your model (do just this to test a model.)
```
ollama run deepseek-coder
```
Stop the server by stopping the ollama service:
```
systemctl stop ollama
```

### Or just run everything with Docker
```
docker compose down && docker system prune -af && docker compose build && docker compose up -d && docker logs -f openwebui
```

#### Notes on first time setup
1. Create admin account
2. Wait a moment for the UI to load, sometimes takes a long time (like legitimately 10 minutes) with my card.

