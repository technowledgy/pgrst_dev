ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg12@sha256:195d91f97e04927b1d73cb709cd0d33d9951d159dbd461c3ad43769164634a20 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:2fcce23f47516ab8d7658bf2c8bc547614b1903d94c2607e407ebb61054b3bb4 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:8d5889f3325f437c655b1306abfb058f6eb23d0d4ff6f62456afe11053eec6e3 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:cc1003cdb5c31a308226cf735735db704e3afab9845713a9660621863b8c5ac8 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:4b37f2238370107e389a95302ae378a2ec790462ab61b2d51ddf41b08fb4bee0 AS pg15

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.0.2@sha256:79369c0cdf9d7112ed4e327bc1b80156be11575dd66fbda245077a2d13b803bc AS pgrst12

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
