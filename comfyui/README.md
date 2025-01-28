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
At this time I'm not sure you can configure shared GPU memory on Ubuntu. On my Windows machine, I have 12GB of dedicated GPU memory, and an additional 32GB of shared GPU memory (this is normal memory dedicated as slow space the gpu can use) for a total of 44. Not sure that's possible to do via nvidia-smi on Ubuntu.  
For now it may be the case that running ComfyUI on Windows is the better option for now. 

