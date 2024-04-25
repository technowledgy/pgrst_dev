ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg12@sha256:8980ca5ca5833bdb7aa7154520cce8cc5e7fb762579c45334488d1da07ebd4c2 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:70c7305b768d237ff0df15b8bacbacd67c6debd0456a62f6ff2901d8b4daf4f0 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:5be422d1e9e709a3d091a77cd6ace3878fae8acc7daf0769a8e6718c4081baa4 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:428e76ba506a19dc8dfbfc791520c0705ee7f084e420bb80a1b58e9fda8cdf36 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:ff7ea6756c1a3956f5a0e31b05298205d2556f07a82b2d44979410c317d09b9b AS pg15
FROM technowledgy/pg_dev:pg16@sha256:94a8b59badae1d805916c2fbe8a0c3a2745689177fb37c50ab01f72035add8aa AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.0.2@sha256:79369c0cdf9d7112ed4e327bc1b80156be11575dd66fbda245077a2d13b803bc AS pgrst12

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
