ARG PG_MAJOR=14
ARG PGRST_MAJOR=9

FROM technowledgy/pg_dev:pg10@sha256:690c3990e510f049b19abab8058593c8521e6eaec8eecd1abd6f0c939c690478 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:d1e911fda6afc6f24b7c50c0e39cb1bd4590f1d78f1f1d8664766f552e2737bd AS pg11
FROM technowledgy/pg_dev:pg12@sha256:8d0d31b8c197af58fe0195da521ae5643acbb0d9fcd77a96b1f4b194520d310d AS pg12
FROM technowledgy/pg_dev:pg13@sha256:326591aa4b45e3d8b1aa87e8ba6b1d2dfe2da1f5b34885d89802b980ada0921f AS pg13
FROM technowledgy/pg_dev:pg14@sha256:14f5f351a13d434a330a2cc678248476b292421f19d7f39056dc83d95b9a7310 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:491685876b731d50bea8d9d7b09b1e784737285cd516fab7351edd64c257c7f5 AS pg14-invoker

FROM postgrest/postgrest:v8.0.0@sha256:4a9e69d24d731b1fa7ffe2691c7943dc1f91121e8d0e2d3e61319ab108f27f29 AS pgrst8
FROM postgrest/postgrest:v9.0.0@sha256:b9f7ba9ecab10c6179e9dacbd65c90c2a794d91bcfbc9589b802db7545e04223 AS pgrst9
FROM postgrest/postgrest:v9.0.0.20220211@sha256:d92a1f1b31f223507efaf05cade53a975cd632784100e9ba098a14cf6cde8f70 AS pgrst10-pre

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
