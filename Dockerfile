ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:8b0549bd835c00fb7edf7a4317ead690092f59781acea8d5709f46f9240b0526 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:49c00db07516cd8933b3875381c892435feb432fa042a8fb9ff0ecd99f063344 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:a4b4629e30f9c3d01d1287878eecef5cf3c86f627377e6dc616fff1b15efcb5a AS pg14
FROM technowledgy/pg_dev:pg15@sha256:2da62d8e0cb8d621e99e79d51f21e790ff4c1dfa59ebb6ed88f9699bef601f00 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:23ce2d16da47705f1b8be34b1a63d54162d049a9d81ce601ee387c36016c615c AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.12@sha256:5f4ce744539bbba786b4e24dbbd95bdb2a956dcf568c5374995a0ff4a68f5bd2 AS pgrst12
FROM postgrest/postgrest:devel@sha256:ffb76291676b17d57c25e7fd76ba301ec0b85e5c793c9c0f7b34d9bccc1aec1f AS pgrstdevel

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
