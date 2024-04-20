ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg12@sha256:0a2260514f69cc18e9e66649d04bd9d57e007c1235921bdff54b29e9b5a3e329 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:7c4dad4019bb035315f0282e366729b23021ce3d469f35bf2ab770508113d8bb AS pg13
FROM technowledgy/pg_dev:pg14@sha256:61be658f9ab1da8f142e86de1094559aeef30d760f5221ae8fbbd90c5dc108d4 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:09c7e953ee412a310a2abd72123cd50c9b6be93c511ca2b18e8c83329edc8ef3 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:361991454d5b07a24e365f016bcad9938280fe9969fcebd60ff4636a10373c19 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:7f4ac8ef74005c7aa9aa200d18160ffb0adfcfb0720a6fb96b572541f6b4bc30 AS pg16

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
