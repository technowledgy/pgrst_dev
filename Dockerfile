ARG PG_MAJOR=15
ARG PGRST_MAJOR=10

FROM technowledgy/pg_dev:pg10@sha256:47e678ec6e97b25268b8877700a84414c1e72c9a867d573c97e8616fb5a7ff31 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:bbc102f791307703ee8b6c7820feae4a55944ef724b123becb8b97af3ba12a5c AS pg11
FROM technowledgy/pg_dev:pg12@sha256:8543037ea285d12fc5737a28c0de3860d3fdbf2d48708f2b8e2e494ee38d9004 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:8ca99e03a7b24aa68d47edbc4e7d4df71a26873b1926a40c5b9221c2da2d1697 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:348e932474b449bda4bd59a3202b384cd718df91f93da6ccc5a5b34b84a6842d AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:ad8190127d3cd7807e84c65ebe6387372f6efb277a1d57d37bc58a28f25206af AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:9b7b1e86eb3567d44f3ee07529321dad56f97d4708ec8e3622000740cc9c4769 AS pg15

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.1.1@sha256:93ef9468e5da753fdf181b0968a0527eaf8de91231804269e4636e8c2626a6e5 AS pgrst10
FROM postgrest/postgrest:v10.1.1.20221212@sha256:e6809059cba6cebf9efd3153d68496f7429ae0b8289eeca4fadff81b4088997b AS pgrst11

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
