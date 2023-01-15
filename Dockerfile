ARG PG_MAJOR=15
ARG PGRST_MAJOR=10

FROM technowledgy/pg_dev:pg10@sha256:1824dedd2d42e27d6c0d615d644e4b0ec052ce91ab320386d4d6c302316c860b AS pg10
FROM technowledgy/pg_dev:pg11@sha256:02a04a2ab695c8f9622a9534ae137682c6603f4bd0c33762a4b8a69ff08d3c62 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:990178ecaa77af5fd08ff39a1cc3ac0a68f10fffdfa2f6031fd01b7b525211df AS pg12
FROM technowledgy/pg_dev:pg13@sha256:4879f357f0d5f21a39dbbeb6db3e68755e71907a6ce0ce6f1f0c6cadd3a2b1b9 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:e7f1213315fc7d9fa1f34821a54cc7711a4567acca32053d5a78c4278ec6732b AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:b1d55d3ff715ea6cb628cf6656f791e6ef487dc399e1b6eab4a8c78927eaa62f AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:c11e02f4f910333a7f0c9a5cccc12a94fcb224139caf4411014a7a0babde95bc AS pg15

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
