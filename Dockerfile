ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg12@sha256:a3b500a91d1ef9ecba7241de8cc50908a3c533c5ced4dd9b8b6392243c7fcabf AS pg12
FROM technowledgy/pg_dev:pg13@sha256:271186ef93776717e191d45b90fc9a676d6be087494e4c480257efe678d68d20 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:71f16f632134219fff377253d113d11c2ec7a71e3170ae20eff2a4da6a96c2bf AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:e45dbc7b33cef4589dfabe41847d61ee5bc1ed1e982286da3b5b2a8523ca54f2 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:20bcd2a55318f0f4cf13efaf4361b189335f057684f7bb2c243ff9349db873cf AS pg15
FROM technowledgy/pg_dev:pg16@sha256:45c228a33a0933cf9c410b90786da0919472f727855bc01447518da2d95504da AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.0.3@sha256:25a7e698337da07976ea830fda7c513ed2e907094337a9833948fd30d9f77a06 AS pgrst12

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
