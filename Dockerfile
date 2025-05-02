ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:ab2afed90871039035936b40768a04e16d85e65fae711d1e1daea43145dfb501 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:670b808cdc3ab5bd9f71bb6021fc0ebf60db40c8e398c8fdc6bbee7317090f6c AS pg13
FROM technowledgy/pg_dev:pg14@sha256:f4f79e80d6a02895efd4fce981fae972d6300fb052d94f00ed55a6aaf41ed7b7 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:cf2d9ccca5484551388f46a811c715f04a781268b90ce8ec2752c58e86c4ef04 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:15888032afc8e1df17eb4a05329d25776dd83c8893804340ec74a5875d1566d2 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:9ad1d6410c5df225ff7080399368263cf58430fbff039024f111f0902da2ba0c AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.12@sha256:5f4ce744539bbba786b4e24dbbd95bdb2a956dcf568c5374995a0ff4a68f5bd2 AS pgrst12
FROM postgrest/postgrest:devel@sha256:50917afb3bc97cd15e49195a5277b9682ab2fe66ab3660537cfc4d0faf421743 AS pgrstdevel

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
