FROM alpine:latest AS builder

LABEL org.opencontainers.image.source=https://github.com/williamlsh/srt-docker

RUN apk update \
    && apk add --no-cache \
    cmake \
    build-base \
    openssl-dev \
    pkgconfig \
    tcl \
    linux-headers \
    git

WORKDIR /build

RUN git clone --depth=1 --branch master --single-branch https://github.com/Haivision/srt.git \
    && cd srt \
    && ./configure \
    && make \
    && make install

FROM alpine

COPY --from=builder /usr/local /usr/local

ENV LD_LIBRARY_PATH /usr/local/lib
