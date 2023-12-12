ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg10@sha256:58be342a7dfdfa6a49ef7008ea8d42874cac00aa08e432a7fd902066d07bc3b3 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:80f89672069c53ab377881d0a6fc957317fc474ca48d8eab4dbdf7c9ab6cbeeb AS pg11
FROM technowledgy/pg_dev:pg12@sha256:e10e01309f4ed7f4c2afbe9999a7ecb7e6c47f9507c4392b109022c227146894 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:bd18dd961a5f6d92294670a44584284c65a0e24c1f79f2f8596d9ae2cac848a8 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:73d6c0e78a2ee7ae8346a8af1001350fb0720f23f1ce83b2397ec28fc0a6ae5f AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:3e9264129088b7e728de9607a5a032a28cdb9f00a13f7806d3b9a694d37141bb AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:abc8a6851964e20dde443ef85590b5ecef0f321bc1a8c5a6f59063c32eb3f69f AS pg15

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11

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
