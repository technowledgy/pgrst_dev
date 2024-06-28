ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg12@sha256:eddaf423e4e7e43469d8b71f4ea54ec29735e666ecc53c30ff8761c349d470c3 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:8f06158bd6fbc8dbaa8cbd4885c00e13ee8bee5bee827702430fe911474dd332 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:c046b0214fed39e7c1dcc7acc1a649fa85309d7cb0b4da8da236757427338f48 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:f6e23b6aafd5da8dae1c1b02cb807a088a3671ce10a0d505661deeff57e40508 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:8edad799e57b265265b019f9da1d4241aa4dcf8083859817228d7fd99c905db9 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:35c30857c9839e1c17959a1914a0e74ac5cecee5df5de26d55b4abb4b77100ce AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.1@sha256:7991389d194ddbba3dffd551682601784cbb1650a815ad9d6caaaf07b094458e AS pgrst12

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
