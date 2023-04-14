ARG PG_MAJOR=15
ARG PGRST_MAJOR=10

FROM technowledgy/pg_dev:pg10@sha256:0d757a6bf5f5a18f75fe307e4d7cb6ab3e7f93cd018cdc526d75718e9ed993c2 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:d183c6187bed757c701de2a11eb7e645134e298317d8d1be8fdc7b4b2683c67d AS pg11
FROM technowledgy/pg_dev:pg12@sha256:9f0b0dd09d8eed5740bdfb014fbb7935ea46be2dbcba6c01f4a17fa9a473830a AS pg12
FROM technowledgy/pg_dev:pg13@sha256:fff59fbb3a7a3be8da584cb5e4a00f651a9bd60dd1a841891f7aef863d5cf4ea AS pg13
FROM technowledgy/pg_dev:pg14@sha256:8d4141337469c147b7ffa33f27876a15fe0b81b0e2aa7e56f0c3f077ee31df05 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:a85ab3195115dcdd23a8436859ae632790f87fc022c306e1e8599f5555f6db38 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:ec1406518644083e96a4749df4911f4431e7e1f3d896dd3e29d40c23974057e7 AS pg15

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v10.2.0.20230407@sha256:e843f6e2ed340a0944669cb6907ff321b4b804c4660c4cf0cab7fc947bae077b AS pgrst11

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
