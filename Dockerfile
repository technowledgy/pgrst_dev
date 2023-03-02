ARG PG_MAJOR=15
ARG PGRST_MAJOR=10

FROM technowledgy/pg_dev:pg10@sha256:188389103afd0e1882ff93a95816c222f7d83ee7012173505ed9a526c69888a5 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:6b661544c191751828b182c162330ed9a12016d9077ba17a53bab4f281ef3d9f AS pg11
FROM technowledgy/pg_dev:pg12@sha256:a6ec9213986620c6741041a335bc82e64571d26361412cb9f7d13ecae8abdf2f AS pg12
FROM technowledgy/pg_dev:pg13@sha256:cb01b36a38c70a6b863a2169eeef65fba021bd6265fd4b92079c3af863410792 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:37bf89e0ce811595c77f8ac730f5e97a5791960fae6741286c0750da6aa8c3c9 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:f063e47943cef5e0a048fe380d902cd85f9b39265161343416ad756bcb7eb312 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:07d6fe079402f96e3ec819d36c6fb644af8a7ce780b4501681aed90f4d18adf3 AS pg15

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
