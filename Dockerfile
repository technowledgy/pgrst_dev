ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg12@sha256:835e0ee4417ea0691f939f25c45d1ad3ae686ac01e5710d21d673a65374b8a86 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:c6cff308b859966966ce48c6a73a7a0359fe2305479d923dd704274f8efe4722 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:fb23044d2c938947b09bb1269dae05bd6e08aba417364791902d97a68e58a148 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:d7faff2af91ec0096b408825d0ff29bd17d6da70b6c48428b4c72e035faf1755 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:1deeec4df669e39e6aff548d7b5bd5cb95c5f876ecbd7eda571043ca65bb918b AS pg15
FROM technowledgy/pg_dev:pg16@sha256:7063d6d44b115bcd09a15770741145accb934b6023ba5e22444fe41588e25987 AS pg16

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
