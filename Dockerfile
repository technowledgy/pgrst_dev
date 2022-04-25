ARG PG_MAJOR=14-invoker
ARG PGRST_MAJOR=10-pre

FROM technowledgy/pg_dev:pg10@sha256:47071ad351caa99e06cb911f6ec21c79a7cb6fb4e29085a43b653becd65979fc AS pg10
FROM technowledgy/pg_dev:pg11@sha256:36e61d137ffbf144e03c5fb9a41586e019dd87a7571d9671daa87e56f12abb05 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:d0cceee8f0eef241ecea778094f318ffbd22eb06d067a0266afcc18392e44fcf AS pg12
FROM technowledgy/pg_dev:pg13@sha256:9dda99d04eb3d4cb599fddfc56da77d975f8d39d9824c2e8434e64ad94917e1f AS pg13
FROM technowledgy/pg_dev:pg14@sha256:c2885d7c56eecaa3d9ec58d46d2f6f3f18042d79eb7275541d55d19d775549c3 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:21373ed81b9bfcc93f36c392bd79deeb7b4ac2121ab21bb85d8cba6ae162f033 AS pg14-invoker

FROM postgrest/postgrest:v8.0.0@sha256:4a9e69d24d731b1fa7ffe2691c7943dc1f91121e8d0e2d3e61319ab108f27f29 AS pgrst8
FROM postgrest/postgrest:v9.0.0@sha256:b9f7ba9ecab10c6179e9dacbd65c90c2a794d91bcfbc9589b802db7545e04223 AS pgrst9
FROM postgrest/postgrest:v9.0.0.20220211@sha256:b82006c3ac5caa49b5d7330e64cbd2792d9d6ab3235c53b909cb9f1ce575af0e AS pgrst10-pre

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
