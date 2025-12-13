ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:9e9a76352969266b2ae11defc361199e6f513f839a3558bd6a9ac6f3266f0153 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:8fcaed875839d9980091a80863fb0733670dc00587a0a9f932cc54500789238b AS pg13
FROM technowledgy/pg_dev:pg14@sha256:8dc8d04e410b766866b09ca9b854ee45c79fa07e07288c10ce6f54d77ced8cf5 AS pg14
FROM technowledgy/pg_dev:pg15@sha256:9fcc38ca0764c08925d5c2e4a27e53269a9336844af43277e7ef9decaa430c4d AS pg15
FROM technowledgy/pg_dev:pg16@sha256:c96a07abad524dbd5b44f8cf882c4fb5f93edb0eba5f22e8597e426a1f6fef2d AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.12@sha256:5f4ce744539bbba786b4e24dbbd95bdb2a956dcf568c5374995a0ff4a68f5bd2 AS pgrst12
FROM postgrest/postgrest:devel@sha256:6fcbbb5700ab2dd43eea59a558f6b64960b3bb401e922afccd4d603fc9a09d8d AS pgrstdevel

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
