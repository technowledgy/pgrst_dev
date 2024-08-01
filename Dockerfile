ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:a47578f89a525588b2d5b19a6bb462ede4f24df0828dd3dde694269f53cf5a67 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:0946b1dee8827f3ec411d564fee6291cf5be2e0e75fca695696914595e19da9a AS pg13
FROM technowledgy/pg_dev:pg14@sha256:053c82216f3dd3ba202ab52adf226ed081e64b6cebf9ee00854fb25ab87e04c6 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:b998eb907ff7d74d39cf3142e3d6396bc532085e87139e4375f8a5794ddd9672 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:8dbe15d6b4b98134dad72b77463af9931eff4966c8140c4e411b135f6645cb89 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:f5eb427b34f4b7a68d1a9a895ca4a65cdea1a4a1f027cb7bcb03c1b86c775831 AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.2@sha256:7755805562a33c0359c768a87d43f2ef6b2d13621778d43d15e12437c83f53a6 AS pgrst12
FROM postgrest/postgrest:devel@sha256:2d98cbab676c08e164099cae9e16d48b7983b78ff904f81290d1fdd7d1bb9e13 AS pgrstdevel

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
