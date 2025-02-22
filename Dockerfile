ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:624d8453361b3e300b9d8931da8709767c2ec99bacfe4d1ee92ec4b8577da3e0 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:85a866e140b2615167456932ec76e1ead0ea77bb2127277ebe3623c4367614ab AS pg13
FROM technowledgy/pg_dev:pg14@sha256:d645fd7f5342d49824854c37299c3945afbc82a18dd6a76deee5760dab4c65bf AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:527a504c12e2e4ddd0e902a3821af0a27d2eed7d05d4c983cd761a2fa66a0272 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:86cb42928faaaaec5fb6d9a9346e2b3aa6c46e3a7f23c0f6135b489f76c971ac AS pg15
FROM technowledgy/pg_dev:pg16@sha256:af6938b50fdd63a208a44fced9a09bd556f56a97f1c11f02ae5b90eb17417ea9 AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.8@sha256:e5978740a590628f2114730bb942f35342ea70b8b7a86697a3df283c0caea109 AS pgrst12
FROM postgrest/postgrest:devel@sha256:99baa2e25184aced60085df3c62c62bf301c5349ae8a304ce120acc020f447d3 AS pgrstdevel

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
