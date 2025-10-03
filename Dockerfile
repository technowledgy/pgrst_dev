ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:127d45f66b1bde4b7e599454d86c1060b755d392069c4a3d5aabf3944a9bb5ee AS pg12
FROM technowledgy/pg_dev:pg13@sha256:ef2c7846132895dc847b617de61309f57215088ed89dd11c88f4f480ddaad441 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:0dd36bd26f481374993707a76f7600cbacde3e4225db7002b9372e89dd65df5a AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:635720a6f9c21db20e87af742445d98f8c24a45cbf604e47bec4534638c1ae90 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:728525ddb3aac237a4c3a4c3a55dad2099901b1227a421a2f94758817aeed19b AS pg15
FROM technowledgy/pg_dev:pg16@sha256:b9ea49042ca6651865531ecc7ae3b1b2b356bd50a149766db6e7224853286417 AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.12@sha256:5f4ce744539bbba786b4e24dbbd95bdb2a956dcf568c5374995a0ff4a68f5bd2 AS pgrst12
FROM postgrest/postgrest:devel@sha256:a5ff9c263c55dded3177703dc552fecd924685dba87c53cc4bd163fa2547b39f AS pgrstdevel

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
