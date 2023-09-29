ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg10@sha256:3217d4a12a3bafd7047900125e41d1ca97026ac33275fcb4c956b635d8a61cf1 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:a6699a60c4e0c00bd82d49ddcbc1b928acb01c0d6723d71a21b0a6e29ac7fc91 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:503b078e6af042f5da240b0d06623346fda5a80f1cc9c2e680846add06f8aa17 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:3a76984a5f8859f226c69874aee3a736ba7bd5017204dbea6af6196f257406a8 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:f67981eeb120a2be45c129a6579dc4240d323d66c9bfbf2e1e6be5764698028f AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:731c8b8fc3ff0ac4b5170faf41df136a0d349cc61d96c2e60984b401365c0aee AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:5bb681065716f1399cbf3fc1ff41f52e220baa5a6bd46e36ed0329a2a7c14fb2 AS pg15

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.0@sha256:9a38d9565ab92675e0ad5db8e2a24f8aa2d2f98accb07a517a61e598edcbc98e AS pgrst11

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
