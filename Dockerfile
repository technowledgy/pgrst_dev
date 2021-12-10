ARG PGRST_VERSION=9.0.0
ARG PG_VERSION=14.1

# hadolint ignore=DL3049
FROM postgrest/postgrest:v${PGRST_VERSION} AS postgrest

FROM technowledgy/pg_dev:${PG_VERSION}-alpine AS base

LABEL author Wolfgang Walther
LABEL maintainer pgrst-dev@technowledgy.de
LABEL license MIT

WORKDIR /usr/src
SHELL ["/bin/sh", "-eux", "-c"]

COPY --from=postgrest /bin/postgrest /bin
COPY tools /bin

RUN apk add \
        --no-cache \
        curl

FROM base AS test

RUN apk add \
        --no-cache \
        yarn \
  ; yarn global add \
         bats \
         bats-assert \
         bats-support

FROM base
