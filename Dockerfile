ARG PG_MAJOR=15
ARG PGRST_MAJOR=10

FROM technowledgy/pg_dev:pg10@sha256:1adb2a73223e62b39aba84fa23c33b1d4134992bd910af69254722b2ad64716e AS pg10
FROM technowledgy/pg_dev:pg11@sha256:4d7fef35052e4e5911f9177bc967184aeb9029cfd9f982828f495eb8157bd026 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:9aba9e68abb1937e8458cdc7f50b7f67f44705c188db67b40e66655a8a5fec6c AS pg12
FROM technowledgy/pg_dev:pg13@sha256:0d126ee8bab5d2eee30745614f129d901cbd417aebe8b48e090bbeda08104fa4 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:dcdea9d9d60a8f45cb1ecc3acfb239851099a6f8cb77234717c1f5a39df1bb8f AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:e0c8e77bc87449b708a768e99568f0489f053e48c10f5083bb8ac5015ad7fcff AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:aa83f2b027c3c531496ade14e3bf535a5ba13c7652248d35ac05dd121e19bcf2 AS pg15

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
