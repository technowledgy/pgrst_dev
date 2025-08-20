ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:b0ca052f69fa3dabc0409e04214ab24375483c763c1e76027fcf15112872edf2 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:4e57242e2e16304d94557d9981f18dba1b5693c71edd05e0a5cb990dccdc62a6 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:c6be5f3b95647b966b1b9f58ea26f0d8f1d483c338353e982031fd36023b0267 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:c19f4660a93c864f258fddebdac46ade57be7028cf502848404f4401123dd26e AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:bd56f90e82725b74fdc085e9c806f280eaca7b58d61d88d207b087289b924b36 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:3ddfdff950efa70dbc9180392bab627edf8c0cac1db4323a125ebf948d32ca12 AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.12@sha256:5f4ce744539bbba786b4e24dbbd95bdb2a956dcf568c5374995a0ff4a68f5bd2 AS pgrst12
FROM postgrest/postgrest:devel@sha256:f7d60cb18c026c49f82da05170ff5cc3d7440e7b8eea72ced79859a7444cfbf2 AS pgrstdevel

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
