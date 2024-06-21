ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg12@sha256:c33b1a6e4dd68e533f4abad8adfb593b38d19fd457e7c62aad3a490216d9d89b AS pg12
FROM technowledgy/pg_dev:pg13@sha256:75a76a8132b9336c134330d8a8e5b070df5f55524b226135fe3d8d0270e168ba AS pg13
FROM technowledgy/pg_dev:pg14@sha256:6dcb19c75e7f421ce19f21949cb7e7f7840cb2b27f34aef56966cac7c7e5599c AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:575191fea87d48158e6adc78a99e28a1631fa551af14b6e0741b6d4256cdbdbd AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:869fe1f19f656c967bf89162b2ec8cb7e97afbb7cc4f3c9ebd8c2e89ef750015 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:ca6b57a26b8cbc95bc060838e30510c2202327f9e8155049a9684e80cbed5afa AS pg16

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
