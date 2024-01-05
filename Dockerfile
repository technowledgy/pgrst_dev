ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg10@sha256:5ff8c87d5c8c2fd9a0293cc38fdfb37daddf3d7dc7d47fb5c8ab75c1a9422dd2 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:b1df77fec62cc84d25870647b36956df7b7beb02f49a414d16fd33e4b5b82453 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:7ddfc6d4f462c9b688d2307a986e77eea4792e57ccbc8ebcd57da516b2a6c266 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:f0304250fb157eb5714ba9c051f263c7de354b03e31d7e6796dd2e4a48f10e2c AS pg13
FROM technowledgy/pg_dev:pg14@sha256:1f417da5ac3637fe576bb471f87db55ac25b15658a95389d68b345154106e400 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:af90d633d213c133a7805c5dc517c24acb0be420946bbb90440af093ec6142e5 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:a4817a03a7d666b8590428795d2a601a6756881dd118702f6f6ab22a7576fb15 AS pg15

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
