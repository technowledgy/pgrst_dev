ARG PG_MAJOR=14
ARG PGRST_MAJOR=9

FROM technowledgy/pg_dev:pg10@sha256:03e5fa9ea8cdd146d90cde195ddfd68f10d318b4981e8fcae30234af0980eca4 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:37a38fd3021d693b1722d4a5a9c151998449d5746508b1796d2647f2c223cd80 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:0f2d8d4260f437dae56bc73d1fba1743019a6e0fd2e78cc9aa7f36565f3356c8 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:d87cbc65822131511e3334ea711fd29c47fb80092ea3deb83430c951c944fab8 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:97b50f0a0ccb363bc2e42e3bb86bbb969e2176324d3008b71a11848720163ccd AS pg14

FROM postgrest/postgrest:v8.0.0@sha256:4a9e69d24d731b1fa7ffe2691c7943dc1f91121e8d0e2d3e61319ab108f27f29 AS pgrst8
FROM postgrest/postgrest:v9.0.0@sha256:b9f7ba9ecab10c6179e9dacbd65c90c2a794d91bcfbc9589b802db7545e04223 AS pgrst9

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
