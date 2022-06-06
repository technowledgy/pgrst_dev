ARG PG_MAJOR=14-invoker
ARG PGRST_MAJOR=10-pre

FROM technowledgy/pg_dev:pg10@sha256:9a585367abd8c8c20267d933bb4b4cd42d66ba87236f25bafd7de49e0dce5c0b AS pg10
FROM technowledgy/pg_dev:pg11@sha256:1e8defc46f974f6692ac663f667845e05fbe6817468e0f4a59ba3dc8c9c811d0 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:fe38fd5ebdbd7457e1c6ce9e2e66bfb57a14f0e59ead4ed03aaec7e97a6c4178 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:ee8f156caf3230d545ade4eca70086f6a76c84fe501c5e4d186388b359485d80 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:e051c6c751586d209d61c3aefee6e3afa0ad42a7bb3d1d55ed13612dd6083d42 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:eb76ddef3d6ef01222d7df42a0dc65547ac67dfc10a76078b6cf84ef80bc90a0 AS pg14-invoker

FROM postgrest/postgrest:v8.0.0@sha256:4a9e69d24d731b1fa7ffe2691c7943dc1f91121e8d0e2d3e61319ab108f27f29 AS pgrst8
FROM postgrest/postgrest:v9.0.0@sha256:b9f7ba9ecab10c6179e9dacbd65c90c2a794d91bcfbc9589b802db7545e04223 AS pgrst9
FROM postgrest/postgrest:v9.0.0.20220531@sha256:ac3bff445d6cb0cf879bda6582994802ccae5f3aaceed5fba6e3d090b5c61717 AS pgrst10-pre

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
