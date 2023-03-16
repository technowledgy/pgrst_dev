ARG PG_MAJOR=15
ARG PGRST_MAJOR=10

FROM technowledgy/pg_dev:pg10@sha256:7136120755ebe968b396d82d26dc3c3a6baf0ae9d9f42760fa74f2afb7f72ba3 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:8152a198240496989046482204e5e8482a3462ed13f86c6723e7b1bd4d712798 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:6324d478071cdb201995fb48812e866ba4d49850dbf92c59c8d53d1fbe26abc7 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:7dbf15a689fdf1f8ebaa560de5ece7ab0db1d214586d58d38e8dc352301abe89 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:a4f2def840459998c23f431cf10a13d80e2d8157d5433ce23e69a5d5731f9762 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:471358ae1f662aa56dfba3b13f8347b1dc8cfcd34c69212d6a81fb7ccf781eb1 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:6e229726ef12543e934bdf25abe2e286d9d75f3058b205a5098b8374568839fe AS pg15

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
