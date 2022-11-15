ARG PG_MAJOR=15
ARG PGRST_MAJOR=10

FROM technowledgy/pg_dev:pg10@sha256:2d99d78f478a5610bd214ccdbb78aecae36564e75c47e76cd27c0122d40de155 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:7ff3178c62f87d51979a7527ae6a34ecc402956ef2f24f143c9e07695bc2459d AS pg11
FROM technowledgy/pg_dev:pg12@sha256:52ef66c3898a61a08dc15d6a355ad1f98f6cfaad704aa1d6d5ffc665b930c7e9 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:81b927e3ff4d661f7abb5eeb09cb7c9da3ec46565a75a4ed201d4f845d7c6c68 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:ba897a97bc4f7961b2715df265849dbb663050a788556ac1eda4c53ca15a906e AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:9b0a4d9aa857c46b4042e457f745b2e98294c28c8f4d86aaed71a96ab8511179 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:3af594a07b7625e2828da0ca79eff4d1cd700aae204e0463b2fe8a3b940d8712 AS pg15

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.1.1@sha256:93ef9468e5da753fdf181b0968a0527eaf8de91231804269e4636e8c2626a6e5 AS pgrst10
FROM postgrest/postgrest:v10.1.0.20221104@sha256:6efcded152e7751d3df22c22c1323cfdce48266da48e90ab1b0cfc1787d37884 AS pgrst11

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
