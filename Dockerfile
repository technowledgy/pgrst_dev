ARG PG_MAJOR=15
ARG PGRST_MAJOR=10

FROM technowledgy/pg_dev:pg10@sha256:e2c9861198f27c6fa52dc1cbcf34aac0e316bbbf5eb6b02fd1c464858c5c531f AS pg10
FROM technowledgy/pg_dev:pg11@sha256:d3e01f580425a15a8901856ed84ae075c3e72764f3df80bc8039d4f2c1b4d8a7 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:1793bb3d296f6115cf3e6f698044bfca25cba986dbc74df920f1d8966ba88e82 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:c3ced1a619f07376c42b81aa8e3efc7cc9ebbf87e37e6601df14b858d82c42c3 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:72a4730435f5ab27f4fc88e0a704d4c7cf12ce065fdf0b7dddb2b3e287be598f AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:786593bcced2074454eb2403cf8e20614cde4c05f7e50c6c937307be3799237e AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:fd7b5244cc4e8d88790429af6c7b911a499312b529ba8e5541257cf481d07f6a AS pg15

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.1.2@sha256:058d34b648f80f7782e1e062df13eb9b541825b38a6b521f3848af86c85be26b AS pgrst10
FROM postgrest/postgrest:v10.2.0.20230209@sha256:cedfaa2cdad6492d8f757cdfb989e65e115f5b61a97c184909dca53d8c5b26a6 AS pgrst11

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
