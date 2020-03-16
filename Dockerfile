FROM alpine:latest
LABEL description="TBD"

# Might need build-base in ARM
# ~/go/src/github.com/gophish/gophish # go build

RUN \
apk update && \
apk add --upgrade --no-cache git go build-base && \
apk del git go build-base
