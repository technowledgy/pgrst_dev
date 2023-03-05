ARG PG_MAJOR=15
ARG PGRST_MAJOR=10

FROM technowledgy/pg_dev:pg10@sha256:c6fb5d336cb950d8411fcef8be87003379a8f1f3bfd01c9763fb2e78aeb08a64 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:2c68aa9e4c285db29bdca0923eb7e084762288ea4d3c1867c1fb39ae0a8daadf AS pg11
FROM technowledgy/pg_dev:pg12@sha256:6f35969423f0cdcdbb9f225ce2c635eb89a645390d2a26978f53f4223cb78582 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:b38e6f2d074cba8db73f9b2c99f7e30f1fde99659d9cfd22d9af9de649a476eb AS pg13
FROM technowledgy/pg_dev:pg14@sha256:dc8a64eb291d1a168443fb7081cc3cce528cbfd9953b38904d50053287613f60 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:a7bd3187e94adfbf772093e219119c9e50d147234d7b609718fc09ef8bf6c28a AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:aaa309a16cfd28bd83aba80e90ae0de18535131c6a5dcb04190c2601e0ac7821 AS pg15

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
