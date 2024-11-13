ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:87cc99a748a569221b79b05eafeffcd32097010c6d19a11be5257e5d79e4400f AS pg12
FROM technowledgy/pg_dev:pg13@sha256:9992752d90275fc397fc1c77d29a4b9b99c8fff2dd49036e5a4853938c00f5b8 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:495481feb3c92674b5661cc2bfdd5a22a1c1a76cf3415b5bde79e9bd13467de8 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:00d7c1d6cc2b86e8e0f36aad7c4d8ae0d209800dad2bbc62ad7fdeeb796557d6 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:0247e913f4179954a7212fe106a1c46f041d9fa3a1b9ba1666d15f534e390e5e AS pg15
FROM technowledgy/pg_dev:pg16@sha256:a73b562023a078c8d284cd36395496cc0602fb9563f772dc8d6ca94037008d55 AS pg16

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
