# Llama.cpp
A general purpose llm server that projects can connect to.

## Network
Create the `ai` docker network, applications can access the OpenAI spec server through `http://llm-server:8080/v1`.

## Setup
1. Start service

```bash
docker compose up
```

2. Download model(s)
```bash
cd /pwspool/software/ai/llama_cpp
sudo wget https://huggingface.co/bartowski/Meta-Llama-3.1-8B-Instruct-GGUF/resolve/main/Meta-Llama-3.1-8B-Instruct-Q4_K_M.gguf -O Llama-3.1-8B-Instruct-Q4_K_M.gguf
```
