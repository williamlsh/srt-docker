FROM alpine:latest AS builder

LABEL org.opencontainers.image.source=https://github.com/williamlsh/srt-docker

RUN apk update && \
    apk add --no-cache \
    cmake \
    build-base \
    openssl-dev \
    pkgconfig \
    tcl \
    linux-headers \
    curl

WORKDIR /tmp

ARG PREFIX=/opt/srt

ENV SRT_VERSION=1.4.3

RUN DIR=/tmp/srt && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sLf https://github.com/Haivision/srt/archive/v${SRT_VERSION}.tar.gz | tar -xz --strip-components=1 && \
    PKG_CONFIG_PATH="${PREFIX}/lib/pkgconfig:${PKG_CONFIG_PATH}" ./configure \
    --prefix="${PREFIX}" --enable-shared --disable-static && \
    make && \
    make install && \
    rm -rf ${DIR} && \
    rm -rf ${PREFIX}/bin

FROM alpine

COPY --from=builder /opt/srt /opt/srt
