ARG PG_MAJOR=15
ARG PGRST_MAJOR=10

FROM technowledgy/pg_dev:pg10@sha256:df3e6c10836984a9962d4ef089bfb442e3eaa75c789e271a53b1e81583869031 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:1caebd78a686a6cd3ff63eab85c1ea1ebff3dcab29555671e845cbf8b7a88a09 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:f7aa78c6410965db92e00c794c2bdd5f5c6d838919f07843053351aac4bf0467 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:9b82a961555ade662819d308c6ab4ab42c299b387f76ca49877763c2faa0d87b AS pg13
FROM technowledgy/pg_dev:pg14@sha256:eb8af575710f9511ec7e240017f7e0f28310a58da21a9993cbfa278a99ad0fb6 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:1bff478034fe678797e584a63cd31201841c245495f4d10d62d6d2a2f4aec33d AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:5d584891d84a5b54343af996d79981eec0cb65c721474f536b8261c5d4f03e6f AS pg15

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
