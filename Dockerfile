ARG PG_MAJOR=14-invoker
ARG PGRST_MAJOR=10

FROM technowledgy/pg_dev:pg10@sha256:581f827c4eeea3fc894e9dee99871ed26440fc129f9e817833de798653b28f82 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:e0e95e0dcb7b6bfb009a61fc199d57443a1c8d56b8d05e85fe393b3611485ece AS pg11
FROM technowledgy/pg_dev:pg12@sha256:94786c8f9276d5a128daca95e37f228745b6bc17b297f5ed93d92a969d495d63 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:e057673680027617dbe68616d58d6ab58890c63094ac22797574c5f26793f26f AS pg13
FROM technowledgy/pg_dev:pg14@sha256:5d24e10e254cfff7ffd88abbf432d4f9c1109d13140fed98c70ec807924b8286 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:3365e5b6692bcd240685be888df651c04140017f6d7278e3bf5a8432f499244f AS pg14-invoker

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.0.0@sha256:db9dd042f5a4f7528b09723e08434b1ffadabeec8079e33ff38ebd8273177100 AS pgrst10

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
