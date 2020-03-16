FROM alpine:latest
LABEL description="TBD"

# Might need build-base in ARM

# Nginx will be receiving ports 80,443
# GoPhish will be receiving ports 3333,8080
# Nginx will redirect HTTP to 127.0.0.1:8080

# Initial updates
RUN \
apk update && \
apk add --upgrade --no-cache

# Basic GoPhish Install
RUN \
apk add --no-cache git go build-base && \
go get github.com/gophish/gophish && \
cd /root/go/src/github.com/gophish/gophish && \
go build && \
mv /root/go/src/github.com/gophish/gophish /root/ && \
rm -r /root/go && \
apk del git go build-base

# Fix config.json file. (All ports exposed, and default 80 changed to 8080)
RUN \
sed -i 's/127.0.0.1/0.0.0.0/g' /root/gophish/config.json && \
sed -i 's/80/8080/g' /root/gophish/config.json

# Create self-signed cert for admin portal
RUN \
apk add --no-cache openssl && \ 
openssl req -newkey rsa:2048 -nodes -keyout /root/gophish/gophish_admin.key -x509 -days 365 -out /root/gophish/gophish_admin.crt \
-subj "/CN=docker-gophish" && \
apk del openssl

# NGINX and certbot initial install
# (including self-signed cert for non-existent site attempts. This will hide phish domains)
RUN \
apk add --no-cache nginx openssl certbot certbot-nginx && \
mkdir /run/nginx && \
mkdir /root/nginx-temp && \
mkdir /etc/nginx/ssl && \
openssl req -newkey rsa:2048 -nodes -keyout /etc/nginx/ssl/nginx-selfsigned.key -x509 -days 365 -out /etc/nginx/ssl/nginx-selfsigned.crt \
-subj "/CN=nginx-selfsigned" && \
apk del openssl
# If running monitored service, use: nginx -g 'daemon off;'
# However, we are running simple bash script, and nginx will be run un-monitored, whereas GoPhish will be monitored

# Copy and setup Nginx default site. Remove existing default.
# this is the folder to add all custom sites. Must end in .conf 
COPY 00-default-blank-nginx.conf /etc/nginx/conf.d/
RUN rm /etc/nginx/conf.d/default.conf

# Copy blank example nginx file. To be used by script later to make each site's config.
COPY test.example.com.conf /root/nginx-temp/

# Copy shell startup script
COPY docker-gophish.sh /root/gophish/
RUN chmod +x /root/gophish/docker-gophish.sh

EXPOSE 80 443 3333

WORKDIR /root/gophish/

ENTRYPOINT ["/root/gophish/docker-gophish.sh"]
