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

# Create self-signed cert


# NGINX install
RUN \
apk add --no-cache nginx && \
mkdir /run/nginx
# If running monitored service, use: nginx -g 'daemon off;'
# However, we are running simple bash script, and nginx will be run un-monitored, whereas GoPhish will be monitored


# Copy script and other initial files
COPY docker-gophish.sh /root/gophish/
RUN chmod +x /root/gophish/docker-gophish.sh

EXPOSE 80 443 3333

ENTRYPOINT ["/root/gophish/docker-gophish.sh"]
