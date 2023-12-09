ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg10@sha256:ae9ffc8e74d6fcff3e628a7d444916546fe3ce735eef89919ae69a1381e0532f AS pg10
FROM technowledgy/pg_dev:pg11@sha256:fafb9b1bcca677d802d8bc3474c88f27c681d894b4fbfa7f3bd6ae6a1353d698 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:4c3eb09ff9b5c0bf9828438f0f4bd1a221cc71f3f2f4454967d4ffffe1a9f2aa AS pg12
FROM technowledgy/pg_dev:pg13@sha256:b440b8835fd5352f9453928499b7d54e5bb0b4f13059b7dcbb4e01614125479b AS pg13
FROM technowledgy/pg_dev:pg14@sha256:d2864f9e03599915c5f3e4bc297a763a316a4d0637ef594f259085c74a9572f1 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:b02516d69a991438e08efa8d06ddf479ed5d889d58d55db067add530c3833b2a AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:38300158414002ad71e480d443efb5185d6bacdd09ae63b2165c27edaf34cc64 AS pg15

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
