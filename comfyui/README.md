# ComfyUI
ComfyUI is the frontend package allowing you to mess around with Stable Diffusion models.  
State of the art models include Flux.1 Dev, Flux.1 Schnell, and later versions of Stable Diffusion.

## Installation
```
docker compose down && docker system prune -af && docker compose up -d && docker logs -f comfyui 
```

## GPU Requirements
Have a strong enough GPU to run these models. I've ran Flux.1 Dev on a 3080 TI with 12GB of VRAM.  
Other than that consult charts for what you can run on your system.

