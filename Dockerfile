ARG PG_MAJOR=14-invoker
ARG PGRST_MAJOR=10-pre

FROM technowledgy/pg_dev:pg10@sha256:60f3a6ae4725ee2971cdfcf26cb5995c87ade89e1e2fcf51c3ed79dfc21a09d2 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:cdda871f2d39e8cd3b4db5d12c77cb1330ee4818d3048bcbeeb01bb8427ce3f3 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:7593b9248e3d2e1fa677f053f7435ec0b71ccea835109c0b194284a7b179e4e3 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:f9be1e11257f461a16415bfea582114adec761061986a539ae0d6c41f84e74d0 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:7c57fbf0d301c12cd4c46e9b1e7f5db27b9a9a081ea45e513f11b44515c0e4ba AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:1119c79c6cf7782b73c4633627642520662f385245585ff48c37a7c64300d3e5 AS pg14-invoker

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
