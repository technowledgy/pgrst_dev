ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg10@sha256:21287f4cbdc06679078f9071229ecb175a100ecdf84e0440ce3d4b0507fe395a AS pg10
FROM technowledgy/pg_dev:pg11@sha256:562c7fd1ca8af223ed130aa96867c64ebfbc3a69d927a5f43e9e8a9be42b2ed9 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:e5f165b42ad86bdf95976b95b8fc6571fb989c8716b5cbb3a3e302429ccc9adc AS pg12
FROM technowledgy/pg_dev:pg13@sha256:540aff24ee65cb20f720e7f448027f14d116bc6a9d58c61b1c3492d78c4f76b3 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:d11a66cca1e1fb24cdee752c341aec2248fd4df558ed9adea18d8dd2d91ce7b0 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:6726aea146f6a1674877f0b9f1b86341a13a20d9c1a238f59897eb48822385fb AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:37c556d066d19b8f4405e91fb5583868dac3ebb074ffd2ca27db7304ee29deb2 AS pg15

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.0@sha256:5cb1228f3d1fc6f3d0151a99180d11b38488c9dd7a2eafd95e9e309d3c2fd9e8 AS pgrst11

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
