FROM  alpine:3.20

RUN apk update --no-cache \
 && apk upgrade --no-cache \
 && apk --no-cache add \
    curl \
    vim \
    bash \
    postgresql16-client \
 && wget https://dl.min.io/client/mc/release/linux-arm64/mc -O /usr/bin/mc \
 && chmod +x /usr/bin/mc

CMD tail -f /dev/null
