FROM nginx:alpine

COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY website /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

