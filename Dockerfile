ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:f5eb38450d07a3ceab4b7dd7a5efdf128d471b7c4c20211b4d7fbc2fa89e7933 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:41a8ef2bc08ae856213762613ce822327fcd866b67c961fd0368857ae29bf654 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:31bd622162d42f26cc4920af5a5c8c4bd64a64691f5b544152b92fbbcf47fa45 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:6291db155f8ebd1e5593f43b64558594f9d21eb6ec41491aac1653988ca5b222 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:ef227914de06b8488d19129e74de03ba3900c463deeaa0e19ac64bcb1f0e3ab9 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:7c2bd9f1bf31047356f18c0f59e294956b5aa0280fcf6b5e59fe8890fdd4a932 AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.12@sha256:5f4ce744539bbba786b4e24dbbd95bdb2a956dcf568c5374995a0ff4a68f5bd2 AS pgrst12
FROM postgrest/postgrest:devel@sha256:b335f3ae1790080629362f70d4b533bf7d0f19280684f33f7361b8d00e2c2980 AS pgrstdevel

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
