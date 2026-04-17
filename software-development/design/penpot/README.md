# Penpot
Open source Figma.

## First Time User Creation 
Temporarily enable registration via manual methods:
```env 
PENPOT_FLAGS=enable-registration enable-login-with-password disable-email-verification enable-prepl-server
```
and comment out `PENPOT_REGISTRATION_ENABLED=false`
Create new user either through UI or through command line:
```bash 
docker exec -it penpot-penpot-backend-1 python3 manage.py create-profile
```
Reinstate old flags:
```env 
PENPOT_FLAGS=enable-login-with-password
```
and reinstate `PENPOT_REGISTRATION_ENABLED`.
