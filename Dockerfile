ARG PG_MAJOR=14
ARG PGRST_MAJOR=9

FROM technowledgy/pg_dev:pg10 AS pg10
FROM technowledgy/pg_dev:pg11 AS pg11
FROM technowledgy/pg_dev:pg12 AS pg12
FROM technowledgy/pg_dev:pg13 AS pg13
FROM technowledgy/pg_dev:pg14 AS pg14

FROM postgrest/postgrest:v8.0.0 AS pgrst8
FROM postgrest/postgrest:v9.0.0 AS pgrst9

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
