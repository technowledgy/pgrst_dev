ARG PG_MAJOR=15
ARG PGRST_MAJOR=10

FROM technowledgy/pg_dev:pg10@sha256:6a5e59c2c16406ff397e72ca0c35da9c629284627fba9da393c10d526d9c3ce5 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:62ccdc460c3d59841c6742e9f950cd9806e4fc9267e404ba09592735036f10e3 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:97a9c61362b6f9dad46aff4efee529eb1b96ce81c6effa5f9a8085fdf0485db3 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:9d40f270e8eac14bf77f7ac3831299b418bd9f600c44fecb0628ce19c3aa2618 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:b1ae6ede912279d96e99312e0ebfd4176d0813134e3dbf4d70393888732e16f6 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:b8c9b1d01ebea6576d7aaac0a01005388e4a5b2307cbedced7b4e746ce08cae7 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:968c1a96c932fde90758364630b3c7bf982df5ced4e041ec9a421b0c39b411a7 AS pg15

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.1.0@sha256:217371be5db8548a88780326522aab4698affd0e4d794d3198154ca87118b419 AS pgrst10
FROM postgrest/postgrest:v10.1.0.20221104@sha256:6efcded152e7751d3df22c22c1323cfdce48266da48e90ab1b0cfc1787d37884 AS pgrst11

# hadolint ignore=DL3006
FROM pgrst${PGRST_MAJOR} AS postgrest

# hadolint ignore=DL3006
FROM pg${PG_MAJOR} AS base

LABEL org.opencontainers.image.authors Wolfgang Walther
LABEL org.opencontainers.image.source https://github.com/technowledgy/pgrst_dev
LABEL org.opencontainers.image.licences MIT

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
