FROM nginx:latest
RUN apt update && apt install nano -y 
VOLUME /usr/share/nginx/html
VOLUME /var/log/nginx
