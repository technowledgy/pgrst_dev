ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg12@sha256:a1edf63a2321000f695c96be94f875b5b12cc2257a10f8123f9941dd31f03cd2 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:e4290d4f08c691cdd32db13c0682e3e0dff9a90f23ae299775bcbcf16cabb01f AS pg13
FROM technowledgy/pg_dev:pg14@sha256:4e1005650afe0536644badb957a46eb1e6877d3219a57ddfb77ec7faa15da7f5 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:fd11acaaa9c5b01119dacbcbd989d144559ce3131c1ef14dda5e46172e86481a AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:27f8835da0eed0ae069213f89722da06f3c320c558d655d305ec22cd4f77c9cd AS pg15
FROM technowledgy/pg_dev:pg16@sha256:17d71dbdde8806a66adcc6123d5f01cedd99c99aed3cae3d686fa3ea4ae1bd23 AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.0.3@sha256:25a7e698337da07976ea830fda7c513ed2e907094337a9833948fd30d9f77a06 AS pgrst12

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
