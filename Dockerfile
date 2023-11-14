ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg10@sha256:a8b99f92cd4080fdc2ace488d380abcd743e1f894f417627efa162a923a40cc3 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:a1ca46c12d2445aff3921db292aec76615e96bc0ab928e1672dda750ea739ebb AS pg11
FROM technowledgy/pg_dev:pg12@sha256:558339ba426212264c4a9749c6eb063eb403b74bdac3250ada1b59d8d42c5ac2 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:d4bc2cbfbe8c3d4695243eccb5136e287d6cfba0ef411d7ac572481671aff118 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:30231f74b108eef767cdba52c0f4bb5f734650cba55db6a1c4ec955ddd3c6e62 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:ccf8fd48f276ecaf044b41f8d739a4c4303de0674edde0dd484332eb8eab495c AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:42811983d88cce3e90ecf577b7488a838f2185a91dfcc2048d9e338b991fe9cb AS pg15

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
