# Taiga
Open source Agile project management tool.

## Setup 
1. Fill out `.env` from the example. You are supposed to be able to set admin credentials here but I had issues with that. Use a util like `openssl` for key generation.
2. Setup credentials using python util:
```
docker exec -it taiga-back python3 manage.py createsuperuser --username admin --email admin@example.com
```
```
```
Note: I had issues doing this call while RabbitMQ was enabled via this Celery util. I set `CELERY_ENABLED=false` to get the call to work. This is supposed to have us use some slower utility as an alternative. AI assured me I could re-enable after the fact but I did not just to be safe.
