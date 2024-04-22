ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg12@sha256:2fe2d387d0fca26ac147e25b7ddf9e1f9ce50d1ac9698acb433587e75c03dc57 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:f89d78d1f9cca3b9aa7d4ef9421394445cd9bece1f91bea131de879280099e86 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:ae5faa99726085204da0ed2106051347c2b478f7c17a1c6a0f73d39a32e3e86a AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:45a719adc145e4a5b9358f3e6aa4f2a51864866e95dde2552da517b44bacbdc1 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:921b463b9e8a6f5645fd44aa2d4cd82568a05197421b955d3ac48218ebbd6c8a AS pg15
FROM technowledgy/pg_dev:pg16@sha256:ee6c81781bdfa4f8b16f43fcbb860d714d1e8723f820fbaa8c0979345271dc77 AS pg16

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
