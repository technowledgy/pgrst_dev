ARG PG_MAJOR=15
ARG PGRST_MAJOR=10

FROM technowledgy/pg_dev:pg10@sha256:a1c5363f7b762adfab5f467f6afafa17192ddbd8498dc95786ace7f067c0c851 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:af59f21bc8e019b8ab9fe75246f102996dd34564cdef4b9644c1cfa93a67c16d AS pg11
FROM technowledgy/pg_dev:pg12@sha256:11248c37b82d8c3196f5e651728beded0726155c55791015530bf384aa258abc AS pg12
FROM technowledgy/pg_dev:pg13@sha256:d78b2bc58e7642be634b4c6356d5c572477d755b4b10fdb4ce2d4c9a9e9449f9 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:c707884f308ab9c32d305be3ed809c5f5f814bd8a2c5ab394beb01e704de6e42 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:0f82e1b2c8123c29a01a1691156f13310fe3b92d0a24a601c4bdc649cebad5b7 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:2166491bb56da4bf0febc35c870b960d668a2ddc7327113863f3893bf2d44c5b AS pg15

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.1.1@sha256:93ef9468e5da753fdf181b0968a0527eaf8de91231804269e4636e8c2626a6e5 AS pgrst10
FROM postgrest/postgrest:v10.1.1.20221215@sha256:a578e057ec58cf599293d9755185ad7c441bd7d0abb9f1f21d0fd116aab7f392 AS pgrst11

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
