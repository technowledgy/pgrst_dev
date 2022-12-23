ARG PG_MAJOR=15
ARG PGRST_MAJOR=10

FROM technowledgy/pg_dev:pg10@sha256:d013aa969b74e5bf6bd850ade1d8677872f21788390a5155207a35a9f5fdf5e0 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:7a338f4916e418d241416ed33b1fb662aad46bb353124834949d9fe975ad222a AS pg11
FROM technowledgy/pg_dev:pg12@sha256:1e9ea220a1bbccb476f2e8c211cf64e0dce32d8790c549e83ce93f6fcec882e8 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:7b346a61c22290b3b803abb3632b81f5fcde63d3b8d064e7e4c7e364e947423d AS pg13
FROM technowledgy/pg_dev:pg14@sha256:5e616bad0ba07beeaeabde59faef47d4f87c07f46bf86a5a7ce3c4d4da2f3c29 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:b0ffc22549db2b77aad6dd9ebcd4d7430e6f423b30ae67edc2dac0d3c5e03f06 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:48ce714f0ff3200d0cbc3ab1528a7b95c7842f72814057a30ab3f3c0fe18b97c AS pg15

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
