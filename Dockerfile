ARG PG_MAJOR=15
ARG PGRST_MAJOR=10

FROM technowledgy/pg_dev:pg10@sha256:a591cd74da53b366db3f10fb665d84c9cfcf8441a09f26a04fd3fe0a33341f1c AS pg10
FROM technowledgy/pg_dev:pg11@sha256:03709f3136065adb264c3a99bde97af65e5843718fa4638f5b5c12233ba801e6 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:bb19e6d846d91e5eeea248c4b4ca536bf26f3b21c8267c35dd0c2f462672f162 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:15c3552c36374f4a97ed3170aa7372a990eba091ff1bccf4b5666a1e97e7d2db AS pg13
FROM technowledgy/pg_dev:pg14@sha256:5655db8fa214199425318886ee61da5a3a58a8d45a7f2e3dc75ebbe1ec5f3bc4 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:9a922eb28f383155411db7e166c8ee972227bde4e5897d9d8664f8c20002ddf1 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:f9466fb385dbc58a0fa2928b7708a4a99a3520090aefd52ead9543ea78213a9b AS pg15

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.0.0@sha256:db9dd042f5a4f7528b09723e08434b1ffadabeec8079e33ff38ebd8273177100 AS pgrst10
FROM postgrest/postgrest:v10.0.0.20221011@sha256:3697575a56cc09460b4d212c78c799304f97640eb6bb3edbc16959b2546b16fa AS pgrst11

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
