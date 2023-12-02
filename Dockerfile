ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg10@sha256:bdbb5eb649140f59706cf1e6a89c2de6c878521366f279c4ebb52965dd27832b AS pg10
FROM technowledgy/pg_dev:pg11@sha256:b91d138a066433e3ef51abdb9f839da47ab80dea58f96079b746baa14ce34ad7 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:8bccd80dcbe530f4db345e51529d4ff2700bf22c544266a7282cd3cd9248642c AS pg12
FROM technowledgy/pg_dev:pg13@sha256:5c140301224bd1904e589945c900ef15e445bb4f28929491c315adb108c89c7a AS pg13
FROM technowledgy/pg_dev:pg14@sha256:b13cbd1567d80a492f3a6ea3321759037b7eb113d1a1360215ab514099391e41 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:d7bc8339cb2e7a2fc690f41cb0d4df49376fb559ba5112dfc4886c1c1732b469 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:c634c495f6f7b84a654df3a95d1bb800d7dae6e44beb3aad168e39e38f63e0d4 AS pg15

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
