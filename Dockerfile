ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:85c15f0ad1db2b18b65bc6de999159e410626914b826ed5a4541f794f9b8a1b4 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:0774e4decb79b3b76069ebc085980a57fb989f5b6512bcf728f2e7a96cfd1005 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:ebaf9b1f0f73a74d70b1e99a32ad86d3759dbcb0d60c42fd243ed4aa82c60748 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:35492729ec14e6add01968ceba016e19a8f038e3d58038d4eb659978888a174b AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:1558cfc2a73852fe05cfa8ca36a3857d595f6d37a1159aeb08119445dde724ee AS pg15
FROM technowledgy/pg_dev:pg16@sha256:6a1873a1548373022c574e25859751213112f3edf639e6b65d0a26055964b40c AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.8@sha256:e5978740a590628f2114730bb942f35342ea70b8b7a86697a3df283c0caea109 AS pgrst12
FROM postgrest/postgrest:devel@sha256:599daecbe97354beba45d865c04640aa863d289dce67c03fcff942f664baa1b5 AS pgrstdevel

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
