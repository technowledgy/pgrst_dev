ARG PG_MAJOR=15
ARG PGRST_MAJOR=10

FROM technowledgy/pg_dev:pg10@sha256:f26b253b1ed03fb6b692fbed174cb45779b6ebad45cb27144206fdc3402e8d19 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:aee0ff4c6c46ecf91491541deca041a4a2977434d520e705104b4c3711d264ea AS pg11
FROM technowledgy/pg_dev:pg12@sha256:1e3c61a375f6f18908b155b918c5dbb953a4da7a41b561335336575f8b1f7d60 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:18e4a8150d7031bb6e0e68902a6b8a00f386e558efd694538e178c18ac3b0598 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:907b6210efc805941fb76f4864102da288577293a5cd481311f1345fc66dcd7a AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:59e99cfcd2a5d101e7707f391f026d48b68bca86521d2a3e6d2541ae5307df58 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:15818acc9a18b1f5e99ba793bb499b666296bb2df34f085449bb658b1a2295c8 AS pg15

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.1.1@sha256:93ef9468e5da753fdf181b0968a0527eaf8de91231804269e4636e8c2626a6e5 AS pgrst10
FROM postgrest/postgrest:v10.1.1.20221215@sha256:a578e057ec58cf599293d9755185ad7c441bd7d0abb9f1f21d0fd116aab7f392 AS pgrst11

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
