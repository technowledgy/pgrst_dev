ARG PG_MAJOR=15
ARG PGRST_MAJOR=10

FROM technowledgy/pg_dev:pg10@sha256:e0cde6bbf45ba25a95e4051c31a6f11ffeff86de7662f4b01ad4cdc040ebcccc AS pg10
FROM technowledgy/pg_dev:pg11@sha256:8660a8845232e6845ebcd03fdf898ae718d1db694463c7da74f22391236fa6b6 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:7fdfa53d57c5e1d2e2186590c304dbb61fe3c410fdc5f7af37563fa7cb1fbc15 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:4bd197b23f21be3dbb5ab922dde321c7c4c656ea5f21fa5c096e71660ff2b2f9 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:cce14fc006f53036c84fdfbf1cab1872c90387c8a59885ba811f4370fcb3964a AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:054543e06eb83b830270363b0bffe990d9cd46b59600304df0b123b00b932737 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:651dc057bb262aa314a30ed22dca0bf74f4dc435c8cec56f6ebc1479cd6fd9f4 AS pg15

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.1.1@sha256:93ef9468e5da753fdf181b0968a0527eaf8de91231804269e4636e8c2626a6e5 AS pgrst10
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
