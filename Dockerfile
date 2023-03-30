ARG PG_MAJOR=15
ARG PGRST_MAJOR=10

FROM technowledgy/pg_dev:pg10@sha256:a6771c08a1348f11b08d1ef3db243f6c42937fc73251f63a29304a9e3206c184 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:48d16040df34af553f8aa29700e7ab1d34bd582acc1785f154828caf5d8273e5 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:9def7b4a18472737979038cd6f63a11f36d5eb91e07527f1aa9206711c93c5c4 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:6c1aee90aa4a7f3880f274e15f41f449c13bf5602cd1f130f4ab7a39bdf267e1 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:ce3fb5a26f2eb16aa96b9ecaa09454ff227a5e9a48d8568cb6d865099621b316 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:28d8ee82126866b75f7acae0eef68330bb3aacbb379f575fba064d3690aac818 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:3b2228c636e6ec88c861203d10d966674139854f298569a9594f0691d5a6c99a AS pg15

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
