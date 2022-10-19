ARG PG_MAJOR=15
ARG PGRST_MAJOR=10

FROM technowledgy/pg_dev:pg10@sha256:c52bc1a1dfedee24f14c2cd0c403ac34866912aa4a82b4e975235f1952fb7e9b AS pg10
FROM technowledgy/pg_dev:pg11@sha256:615b53e94f58f600610e0fa4fe40dc673aa8e398849a70ab440274b759be4008 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:04e3d24a1c3b0251d48b4d01439b38547f5f85b0c79b13180d081bf036268f11 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:8f984990fab42b026fe1e1310c20d04f81dc5182085ea8f07b0ddd0e56f04d99 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:6c624985765b01325846937a74806f4852557280ecd2350318016dd1694ecdb0 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:ba534f9433046d36689625580ce49f2f26d156a988eefa6f28d16ea99bf69a32 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:69367c14e667ba8a03562c0db269fc19ec8da76df915393404c080ad88b7fd48 AS pg15

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.0.0@sha256:db9dd042f5a4f7528b09723e08434b1ffadabeec8079e33ff38ebd8273177100 AS pgrst10
FROM postgrest/postgrest:v10.0.0.20221011@sha256:3697575a56cc09460b4d212c78c799304f97640eb6bb3edbc16959b2546b16fa AS pgrst11

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
