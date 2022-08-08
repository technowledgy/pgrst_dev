ARG PG_MAJOR=14-invoker
ARG PGRST_MAJOR=10-pre

FROM technowledgy/pg_dev:pg10@sha256:fbe23c6e23a23777bd52be97599cfe45fc3085c1e5fec6f60ed5514b31727edf AS pg10
FROM technowledgy/pg_dev:pg11@sha256:8307a06d58cac29e7802a02d5418d01815d6555b04b2325c37d5063dede27a15 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:189c4418735f472e34c1d187f1f085be329638940f02bcf1f16dc73040ad27a7 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:e825b6ca070e6bafa0f91dcb6bcc8185210657d3750da8f93c0aafe1a905b5e1 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:91a7ac264c74de1c98c83c2d58229690895bb5a7d245073594ce218312cb5ff5 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:28132515bff6c5552aa36cb720a0841a69e048bbf58ca4a242124b495fb35b91 AS pg14-invoker

FROM postgrest/postgrest:v8.0.0@sha256:4a9e69d24d731b1fa7ffe2691c7943dc1f91121e8d0e2d3e61319ab108f27f29 AS pgrst8
FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v9.0.1.20220802@sha256:39aadf9358fccb8b6a20a7136517a79e4f6f7ea367c19071fae4639012bdb3a8 AS pgrst10-pre

# hadolint ignore=DL3006
FROM pgrst${PGRST_MAJOR} AS postgrest

# hadolint ignore=DL3006
FROM pg${PG_MAJOR} AS base

LABEL author Wolfgang Walther
LABEL maintainer opensource@technowledgy.de
LABEL license MIT

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
