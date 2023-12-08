ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg10@sha256:3f9e3dcf5b94b1760ad5dd80111cfaa676059bd223027f88858aff93adba03a7 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:fae6f9d3b258744222eeb025de975d8456dab539d3ab218660a9dd44d6b05b82 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:ef7f4f61872884587d27125387560afa5ae9e1535b7242cf6d07470fffbd9048 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:2479b4203ba331321267c1b39c0be55a63fb75f8e0824682e400568ec878e139 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:55692aa5098c6bd96e404c7553d2e3366f63c5a5027e0703ae698acaa924eb99 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:f29815666da460e269fa4644834e7c087deb2dd76c0dd606af1cdcbc04a62873 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:bdac18b240d48fd21c0852803459d3e2c94e98cb836566987ddf3168cc52ace3 AS pg15

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11

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
