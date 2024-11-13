ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:dc90c6bbdb4c3120beff7e9d3f3a7433d184b94e1f8a663710f8cafb9e3fc0e9 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:795b7e208db2d39ba9b79ff5397a05a9cfb6a8212cdf79764e4b485c95afed7c AS pg13
FROM technowledgy/pg_dev:pg14@sha256:24b6a4346adb7cd6f76df8338e44bba35765ca1bbceaef9b9a64d857d72af075 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:00367b8e7f3b5bf099825ca9d517f5c0b75afa767ca38a0d4860250fba437a49 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:9aeef1b6323230fa08071cc9eff5a1088ba6c8b34d06b9b1fc7feef76808b9d1 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:36a61d6cfe4d35260628e9539d16acfc5172f7da65c8998a160927175f931d6d AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.3@sha256:729bf65c733b73f5b52777f0e4b853f22ed73aa67a22d38269d289779b0a8401 AS pgrst12
FROM postgrest/postgrest:devel@sha256:a6b500fd40dad2105e167d22bff86c93c64b6134ac9d9f52484d636670419d74 AS pgrstdevel

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
