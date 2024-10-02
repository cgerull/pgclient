FROM alpine:3.20
# FROM  harbor.cicd.s15m.nl/docker-hub-proxy/alpine:3.20

ARG TARGETPLATFORM
ARG BUILDPLATFORM

RUN echo "Building for $TARGETPLATFORM on $BUILDPLATFORM"

RUN apk update --no-cache \
 && apk upgrade --no-cache \
 && apk --no-cache add \
    curl \
    vim \
    bash \
    postgresql16-client \
    minio-client

COPY scripts /scripts

CMD tail -f /dev/null
