ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:3a45046667e84245effc6516fb6101ade426297ff682857552cf343c4ba3f7c1 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:402fcba9a6f8beda60eaeb9c199430c10c8c755f62fb934fceaad16713e8f92f AS pg13
FROM technowledgy/pg_dev:pg14@sha256:cb0362ccc8f21e68b67711c23bab3328c8df54ebe12c8071979ed05b62f68171 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:a667024be93377d9c379310aa20803895694d36b826e2e22868614d907f42875 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:6b3bca79d1ba1c68990cd52f189b1ca04265f06ee445d946b4c5d87ff0b4be2b AS pg15
FROM technowledgy/pg_dev:pg16@sha256:26b3276a687319298908a3fe7d3b467d567ab0d603561c5947ef2208ab433c29 AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.8@sha256:e5978740a590628f2114730bb942f35342ea70b8b7a86697a3df283c0caea109 AS pgrst12
FROM postgrest/postgrest:devel@sha256:03eca1eb1a439a8a36bccbc41b5a9cb6b755e45dfe87750b801683a9d4bb8115 AS pgrstdevel

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
