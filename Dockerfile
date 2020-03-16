FROM alpine:latest
LABEL description="TBD"

# Might need build-base in ARM

# Nginx will be receiving ports 80,443
# GoPhish will be receiving ports 3333,8080
# Nginx will redirect HTTP to 127.0.0.1:8080

# Basic Install
RUN \
apk update && \
apk add --upgrade --no-cache git go build-base && \
go get github.com/gophish/gophish && \
cd /root/go/src/github.com/gophish/gophish && \
go build && \
mv /root/go/src/github.com/gophish/gophish /opt && \
rm -r /root/go && \
apk del git go build-base

# Fix config.json file
RUN \
sed -i 's/127.0.0.1/0.0.0.0/g' config.json && \
sed -i 's/80/8080/g' config.json

ENTRYPOINT ["/opt/gophish/gophish"]
