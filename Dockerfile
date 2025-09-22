ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:48f06d7c61304d518fb440dcbf20b70eb956936bae750aff4ef1dcb8ca279eeb AS pg12
FROM technowledgy/pg_dev:pg13@sha256:2552850e6813c65790fce117791d5b369fd2c521a6fb275028dcb9b583274b1d AS pg13
FROM technowledgy/pg_dev:pg14@sha256:037b0cde63289cde3cc069312c1344ac902528b427cba7a2b5825679476dd7e4 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:6ec12ec20a54d8bb427f3572f868ba1800d89a1720eff96449dd7243c5d1d5d5 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:d2e5b16c079e02103d267475bb9bad28009679778fd36b24b11df9e45a164912 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:efbe29b8176868c93da4d317039cd182a5f493d9e5975f71117d0a3cba2a5c12 AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.12@sha256:5f4ce744539bbba786b4e24dbbd95bdb2a956dcf568c5374995a0ff4a68f5bd2 AS pgrst12
FROM postgrest/postgrest:devel@sha256:a03ad1c72bb52bc9f7b3deffbb239a1b1ebab28b5c00d9389ea268f045015e1f AS pgrstdevel

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
