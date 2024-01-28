ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg12@sha256:800886bc32f66c05534937c938850e54f845f9199449c73a9a4ab3ce60833662 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:585d146d850d95a7bd465efc6f55a28a258b22dd5bbb2de01828d9203b84c759 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:b45de4514ddeb17472f2e874b0177199b5556f1f861b5e682da3122cbc2a182c AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:bba38bffd122876ef68fa2ffab67b361bf9ff6b9d3391292a992088ba04a8145 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:6d3b5a0e93bc4965a33cc1a29842f885f7e4a36b6790bb17d48ae5840551dac3 AS pg15

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
