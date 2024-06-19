ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg12@sha256:7c362bc8d31b9bd54b0d42b3df6c8c3c45171842ff35eafcf5ec4f8fcec2d918 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:a8c09dbef468e5a384cdf897bf953c9e9fa0a5fc1e2ea2ec0c04a907e6d455e5 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:8db252de1b6052fffec51756c0f56b1bc578d95ace0df4d45cdcbcc7be8bf82f AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:2d249e0f512647753fdd3e61f0613ee13021dac38685f6a4b63d558eaac6deae AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:c394dcd19668cebb99190ab8b23d63d802dca45e2b25f33599eee957753c5a94 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:a9943f8eef7c8910410379472a0bf15d1bba84731e321c9c2bd3a2c1e3960957 AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.0@sha256:2cf1efd2c9c2e7606610c113cc73e936d8ce9ba089271cb9cbf11aa564bc30c7 AS pgrst12

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
