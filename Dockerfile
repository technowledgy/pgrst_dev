ARG PG_MAJOR=15
ARG PGRST_MAJOR=10

FROM technowledgy/pg_dev:pg10@sha256:86cf1ebf59a24c049bdc6a2e339da6a46e0a3d1aa725e29db655e4d52b1d3358 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:938f13c92d538a220b173be4bd29f85b4286ee31fe8a428d5e5dae6168bd81d9 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:67b13d637a1d9e13882b5d3f007025659f0af3f9eb4fd3c2c1beadf806fb14f0 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:4312525994dd50f37346625c7ca194e948748d8ddd4da4dd4ed8fa38f6f5ed06 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:8307c3268d2f3a7f448f912c26497f867ca2b8363034cd4d07463d7e4883174e AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:736990aac444a36cf3c11225aeac0ed5f6012e6dae6c5ae36c9907e8fdbe2637 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:d023d4b5445a72bc8b6bb18c0cf3c23fdf5fc06bd4132ec7ea14ea0324f6d473 AS pg15

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
