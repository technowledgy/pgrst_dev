ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:8cac78ec26534b920c38ffceec23c7f8393b5f5606296d2e0e28b15ceae3846f AS pg12
FROM technowledgy/pg_dev:pg13@sha256:a41526b6c65bf62cd3ceabfbd2f23e7d97afcce691692fd0ec15a25d26cb54d0 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:491ac46d8fd5d61f1cd7e2fe83f5eb74dcc341e8d3eba53711afd00abdd9e995 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:35a1f6a56b856188a658b4d7147a12ed8d64e32c523241d8522bf2ca55caa493 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:106d6be844c6922c34c207a3c55e5b0e898e384f6e6b9bf290e0c5c4fcc49d34 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:841b09c32dbee37894efc6934f66ceb561cc4e5848e0e3b1b4235fdede649fa8 AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.3@sha256:729bf65c733b73f5b52777f0e4b853f22ed73aa67a22d38269d289779b0a8401 AS pgrst12
FROM postgrest/postgrest:devel@sha256:2d98cbab676c08e164099cae9e16d48b7983b78ff904f81290d1fdd7d1bb9e13 AS pgrstdevel

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
