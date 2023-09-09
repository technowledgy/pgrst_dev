ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg10@sha256:7483ab489df180571dafbdc4ada5b328a71554e1801df7aabb90d3acdf76bb09 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:1036a5d6d9e9e986fa1a3c54ef57fe1ebe100cd020322975e9c8b89868208264 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:cf188590b95b4494e5bb298965bc98b7995f204502ee8338115c0b160fcf1cfd AS pg12
FROM technowledgy/pg_dev:pg13@sha256:8da341e76d8a3c4810f32226639056f6ad6528a225acfdda9ee7a8d969d9f4de AS pg13
FROM technowledgy/pg_dev:pg14@sha256:88d0a35f1e7c37fd7ed4ab0fbb2e6555e0c4bffe2639a8060bb40ff5106609e3 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:1e8ecb73476fe455de1d9117bbc58318c70b376231422a4315bc251970c14975 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:ac735ed7e44f7f40329fbd7a0dbef2557060fc3970f0a9e7afac54c5f707933b AS pg15

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.0@sha256:9a38d9565ab92675e0ad5db8e2a24f8aa2d2f98accb07a517a61e598edcbc98e AS pgrst11

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
