ARG PG_MAJOR=14-invoker
ARG PGRST_MAJOR=10-pre

FROM technowledgy/pg_dev:pg10@sha256:f158138cfcacb9f431c1f55e08e88db5fab1e44621ac015bbdb9fc518d5061b4 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:5872c5d1573ea2316d0bbf725b50e08377eb2cfcf14313747b1105a3795b32f9 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:5eb71bf00d5f29ada4ba0628e5516fcb14153b53cb93ad11b35e958b9d9fbf42 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:6a57a285a6d32c04d060685ec97e818553f6a03cbff9d65749cf3749ab7a8fce AS pg13
FROM technowledgy/pg_dev:pg14@sha256:9d24082f565c14076967842e9818d64572970d168411324b99827d0f4787b5c4 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:d5feb5855340995a8335a129703d7e1957268118d52016c861f3dc9b421cfd50 AS pg14-invoker

FROM postgrest/postgrest:v8.0.0@sha256:4a9e69d24d731b1fa7ffe2691c7943dc1f91121e8d0e2d3e61319ab108f27f29 AS pgrst8
FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v9.0.1.20220802@sha256:39aadf9358fccb8b6a20a7136517a79e4f6f7ea367c19071fae4639012bdb3a8 AS pgrst10-pre

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
