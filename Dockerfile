ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:631e6f046c7c57d996390bc77601e9d90c092468291425d011d0af83aa319ff8 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:c12a8a6bd3f6a37c693e1d09b20ffd4ee49a1cc65f1eb58fc48fd37f3cf0ab20 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:3af65b89b2cfdaff762be4192eb7536d70b100eef7b019e97a0f868373471a1b AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:a574d2b6f1717646f3c3abc2d4adeaf8b95dd3e12a5eb04c8dab6d658aad3790 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:45cc8363ad7ed2598936433421ff85a53c0b1e88432d2acd8408b0f941c91e3c AS pg15
FROM technowledgy/pg_dev:pg16@sha256:e816dcd7dc3592f18a312d857ce028caa54be5c4411cc6498d8748b6308f3c7b AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.5@sha256:67c851793e115be6afba434bfd41908dfd155b868f0666ff11d6006be12c03ab AS pgrst12
FROM postgrest/postgrest:devel@sha256:23bfd7580895530cac3d932e5725b2861243b0589181c1864ebf456c827ef516 AS pgrstdevel

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
