ARG PG_MAJOR=15
ARG PGRST_MAJOR=10

FROM technowledgy/pg_dev:pg10@sha256:103d4782ef265a9d2645fa373a319b8d6e00d87899ed29b4a939a60497da28bd AS pg10
FROM technowledgy/pg_dev:pg11@sha256:af422e4f1c7165e847fb1bbc8efad885199d9fe314f1fa88f5a0b70e1eeefb33 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:03d344b3f9b6cdac463a666bea6275c8bb1a07015179685086f89ef7613a7fe5 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:915f06c6221c1d6d2f4c6947abccd5c364fee26138e0574ac56d768a455f6c6c AS pg13
FROM technowledgy/pg_dev:pg14@sha256:7e305ef0da8c9f6356ea3f0a78566773a4d972e886a8dd77ec51cbf37bc7d3de AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:1133c8518e2984dc7cef610eeb0d7b338f2b34c3c39ae9a7644799634e98258a AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:1dca9ac3de7fd06aa01236db9703b20bc02156bb014a0eb02770fc8c818d07ff AS pg15

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.1.1@sha256:93ef9468e5da753fdf181b0968a0527eaf8de91231804269e4636e8c2626a6e5 AS pgrst10
FROM postgrest/postgrest:v10.1.1.20221215@sha256:a578e057ec58cf599293d9755185ad7c441bd7d0abb9f1f21d0fd116aab7f392 AS pgrst11

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
