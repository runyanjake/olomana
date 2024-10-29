FROM nginx:alpine

COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY website /usr/share/nginx/html

# Exports 81, overridden in nginx.conf
EXPOSE 81

CMD ["nginx", "-g", "daemon off;"]

