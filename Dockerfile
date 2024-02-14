ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg12@sha256:0c51b7ee37a9df0de6b7189695880d80689c2bd9a8d21f37cb7352c1f26eb218 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:a73b94f3a561b4b691c9792cf8812ef750da20c74eacd485f8adabc0188f86d6 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:0bb630eac9b52f994aec7138401bc00a5b5e03e15f1dd5f83d075862e6e17eb0 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:54403052239b8dee9e4ea86d023e16ba25c98a336cdc4baa576e7080557146f8 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:496311a4172ce811bf6110e0fe0cedb927698ae761450b43843108042a4b04dd AS pg15
FROM technowledgy/pg_dev:pg16@sha256:6b781df03290432359bed870da831092ce1f49d0de67958efdf388efdd3f36b8 AS pg16

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
