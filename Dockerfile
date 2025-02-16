ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:0ecdde596d6070ca22fb392bc233d0dc7e0ea37964795f717209f0a92f2c3c1a AS pg12
FROM technowledgy/pg_dev:pg13@sha256:267cd2de1be1ddd7f637ace9e0e19a38fb05d81ef22253700a4bbbc79f85dd58 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:5ca214f655aede13f53568f9970e053528370ac3eefa5335542456b018dd8bb9 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:41b0b3565244523582fb1dda2d9e0bec2bcb51cd9720bea1ef950f49180e1fb8 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:8da8f15d350bcdb72e1f36431d64f0ada143bc3d8e42cc075431988f8aebd096 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:3837070e7d3fadd8df7818072c52170d128049c507ccedd0009e6ded0b82dd4c AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.8@sha256:e5978740a590628f2114730bb942f35342ea70b8b7a86697a3df283c0caea109 AS pgrst12
FROM postgrest/postgrest:devel@sha256:03eca1eb1a439a8a36bccbc41b5a9cb6b755e45dfe87750b801683a9d4bb8115 AS pgrstdevel

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
