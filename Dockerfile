ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:7c8d023bfa7bdaa43a090e5227e889f7b0744b2c722215bb9b5a49c67f269dab AS pg12
FROM technowledgy/pg_dev:pg13@sha256:40d5c9b2581eac2b0a0bf23fe239c8506a9f47410b760175e6dff4a09a1074c8 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:9bf796d479fa8e1fede4f966269d712b8015a900b0f0d0ce033dd5bf07a86047 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:6368feacfb2146127ee2700ea41249745d8edd7576a879882d220977d4d9d572 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:7a5905ce21700ec4f150e871c0e1a345877e2165753cff23ca5e581989db6472 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:788b573eaa2a8ed1a0f6e6aba23398e455f2bd9907aa5cf423bb6b725517bcfc AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.8@sha256:e5978740a590628f2114730bb942f35342ea70b8b7a86697a3df283c0caea109 AS pgrst12
FROM postgrest/postgrest:devel@sha256:c222b143200f4437e91c823830fd11ed39aa634e59947e53489f475dde4a8927 AS pgrstdevel

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
