ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg10@sha256:a068cf19dd614d72682e8ebb1d0d2a8b1496c46d94c078bcc8751997294123ff AS pg10
FROM technowledgy/pg_dev:pg11@sha256:c7ee5a2ba6e7e548226ad812f9dc1bf746613f75b84c055072e2490525900424 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:0d0c8fd44325dbe4627b554c6f69b152b7612e1c4cbac98c76baeba33a95a5f5 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:33dedb0142a58bc1d749c0e62afe4020c0743e619515b128d1828a05382ad93e AS pg13
FROM technowledgy/pg_dev:pg14@sha256:614d2755233d143003d77499eb8ed6759092c9d93ccd1d9d91d4aee1d046f8fd AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:73a2dedd7d68d87bad6645dc8c183a3402538165989d9809eb2af2feb1f10b49 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:6d438dc57b2feabd1f3427678abad85dd91ef7a07b231a42be0c3f3b10e46256 AS pg15

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
