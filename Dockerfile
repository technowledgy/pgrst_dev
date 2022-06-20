ARG PG_MAJOR=14-invoker
ARG PGRST_MAJOR=10-pre

FROM technowledgy/pg_dev:pg10@sha256:6d46dce8555fa592c2bb2dd765dfa24c0d6a3b85349610768b1a7fdec1a310f3 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:d776488f64b03e8fc58d206d63e885e7f02820d3dbac08d735e0d884c86d5ad3 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:7eb504513025417dc792639cb127e8f219e3ecc71f9d2f1cb1a693a435d2b508 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:f214a48fd3e1a1535ca51edfd57a10c4da4b1303ec37ff0f2a603f016414f9f6 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:5868e3ae363eda02c57148062c1cbd3628ad3b23ca64984247659bfc21e94ddb AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:9e54b3f8aeb769e47100c3afc7647dd4b8a15494021113adb570ea694e9112ad AS pg14-invoker

FROM postgrest/postgrest:v8.0.0@sha256:4a9e69d24d731b1fa7ffe2691c7943dc1f91121e8d0e2d3e61319ab108f27f29 AS pgrst8
FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v9.0.0.20220531@sha256:ac3bff445d6cb0cf879bda6582994802ccae5f3aaceed5fba6e3d090b5c61717 AS pgrst10-pre

# hadolint ignore=DL3006
FROM pgrst${PGRST_MAJOR} AS postgrest

# hadolint ignore=DL3006
FROM pg${PG_MAJOR} AS base

LABEL author Wolfgang Walther
LABEL maintainer opensource@technowledgy.de
LABEL license MIT

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
