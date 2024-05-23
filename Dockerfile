ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg12@sha256:5ccaa5bd0f9ebd3d9c0ebbbcd663d940f11b52d9dee1b9c1e49c6519e2c256ef AS pg12
FROM technowledgy/pg_dev:pg13@sha256:d1bca8c6baafb9c820fad84e711fdb956c7f51dd2bd79b560a45077a2ec1b0b1 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:bb4c6944f7ae9f299079fbe562e311faa216b3e1dd40f4b5a23be7799f3551a0 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:42f2f4af775d6a4feaa454ae46c07ba3fb0f37ca8f4743ae7cb09caca636323f AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:aecbcd24328777659714db274ca7af2e6634a88a6c95818aa4fccba66fcfe78a AS pg15
FROM technowledgy/pg_dev:pg16@sha256:e60c8ac75572bca241fb787f5563f31114ffd581692e99e468315799f3f8738c AS pg16

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
