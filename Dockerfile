ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg12@sha256:f358bde2bf95c7ad32d484e7f2a26b691824dc89c620084775122a2cd48ab93d AS pg12
FROM technowledgy/pg_dev:pg13@sha256:3781b4c79643e9c7b802834f2f5c1f53ed146d20d0f44f13fb40a1875dbc20c6 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:3d031abe507196c33ec4883b1688c6d91ee5c4073138cfda3eb45ed4241fa468 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:d9a93ace64d6e70606d851a649fc5bed07f321371be581935edfc9c5417364c0 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:792f01e0c5a27eb4b49e27bda036df5b62044e7e95beb96c8c4b96f60b165654 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:347635e02f74ff802d50ce2998996c10c7f16cbb10dffee072fb5feda03d4cab AS pg16

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
