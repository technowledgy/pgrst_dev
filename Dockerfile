ARG PG_MAJOR=15
ARG PGRST_MAJOR=10

FROM technowledgy/pg_dev:pg10@sha256:c27f88c5bebb4c604f88558d009bf134b65f6176d56b7cb5ba62d9ce4d41f305 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:198b0fe5143a6fcdd297f5cb76342f471c1a2ec398b7d03990257fab91caf9de AS pg11
FROM technowledgy/pg_dev:pg12@sha256:ae9eb1d0fc0c191054302a3c229c7122c2cc9489b4e56342fe97facd4fd0e22b AS pg12
FROM technowledgy/pg_dev:pg13@sha256:380bfd2ec7b879475a443729f121b3bf2bfe0a2ed9f0c673d631ed863b52aa32 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:40948c27e1b0459cfcc575cea1112509b8052e2f26b3f6a252f3908a77a8b83b AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:2aeba766254e6d195f03f511ee431581325e7d4be85acf1ec49bf77b7574a73a AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:ef7469379ab2c048b2f4e8115eaa0b1e0a9e54e12fab901e4a3f8152e1222170 AS pg15

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
