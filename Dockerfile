ARG PG_MAJOR=14-invoker
ARG PGRST_MAJOR=10-pre

FROM technowledgy/pg_dev:pg10@sha256:b31ef4f477132ec30e74cf9bcdd87a879dcffa4eb8321a52b1fbe0bcfa8a529b AS pg10
FROM technowledgy/pg_dev:pg11@sha256:aa575ac06157744e2b4fcf5be18fec3e14c885bc05bc5e5e4db80cc21f0b4462 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:78c86c51f9e237bcb3c4474067ac08cb4eb312de9430d591623f54ce5b6db638 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:a7b3869f3d487845f229f8b77fc499014165c800e3f440acd8978e90fe8bff4c AS pg13
FROM technowledgy/pg_dev:pg14@sha256:82f3808e45c36ac9a7129268a30997df2a9f86a28a200d0b3960c5baa267862e AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:242459ba53e6595e0ba569f7cd4f53fc51ab202077f9db845d2af656f853b32b AS pg14-invoker

FROM postgrest/postgrest:v8.0.0@sha256:4a9e69d24d731b1fa7ffe2691c7943dc1f91121e8d0e2d3e61319ab108f27f29 AS pgrst8
FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v9.0.1.20220717@sha256:efee06d36db67cffe9091c5984b333f9e06a31a42196db7cebf8f72b72adaa17 AS pgrst10-pre

# hadolint ignore=DL3006
FROM pgrst${PGRST_MAJOR} AS postgrest

# hadolint ignore=DL3006
FROM pg${PG_MAJOR} AS base

LABEL author Wolfgang Walther
LABEL maintainer opensource@technowledgy.de
LABEL license MIT

WORKDIR /usr/src
SHELL ["/bin/sh", "-eux", "-c"]

COPY --from=postgrest /bin/postgrest /bin
COPY tools /bin

RUN apk add \
        --no-cache \
        curl

EXPOSE 3000

FROM base AS test

RUN apk add \
        --no-cache \
        ncurses \
        yarn \
  ; yarn global add \
         bats \
         bats-assert \
         bats-support

FROM base
