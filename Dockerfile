ARG PG_MAJOR=14
ARG PGRST_MAJOR=9

FROM technowledgy/pg_dev:pg10@sha256:acf7a567925d07199a7ed318484064ba6d3181a6a32f9356d4bbd2f25a12cff5 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:7a92febd5fa8ed5f5fc8f5efe98b66a191809c6c9958d9b0c24babc3eac22992 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:a3f7862a43621811f1b847ec78e8f540ff16fb54023de53327459f1925e1d6c7 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:d19e384e50f1d25ce902e6cbff10f4fac2a5a2241724ab87c419e850d19f2180 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:e959d183a55e4322b781297873da91feeeb33d36fcad6949e85ada9283e160e8 AS pg14

FROM postgrest/postgrest:v8.0.0@sha256:4a9e69d24d731b1fa7ffe2691c7943dc1f91121e8d0e2d3e61319ab108f27f29 AS pgrst8
FROM postgrest/postgrest:v9.0.0@sha256:b9f7ba9ecab10c6179e9dacbd65c90c2a794d91bcfbc9589b802db7545e04223 AS pgrst9

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
