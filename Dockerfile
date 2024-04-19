ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg12@sha256:d9590367014f9f5ee82429d449f9d3eb9bc5a349199f6365de8b815a1574a11e AS pg12
FROM technowledgy/pg_dev:pg13@sha256:925db0b1520e3c8a13a4d10699550058f8bfbd32ee5309f150c6fd1c022befde AS pg13
FROM technowledgy/pg_dev:pg14@sha256:9ccc12d731d912d727bd0c6a824976b4c3b6aba9c55771cf41e08c87e53977fc AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:a571c3ef1d5f47f170b83db8d1f41ecb9dca509d833dd2e613999d575e36f01a AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:3a4d62dfa4381978ee6d4b894848c821e081b8fdbd8257d756a3b155b2ac478e AS pg15
FROM technowledgy/pg_dev:pg16@sha256:3bb084a5f572bf76ed36901a9e17e8b1d79936aa4ff5e519efcd1d12249744ed AS pg16

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
