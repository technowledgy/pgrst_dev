ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:2aca522b24caf4a26d9c2af3ecb7148f4ce19b5e9fd20666e8d757f25cb91da1 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:aafaba656a2a1a32fc4df8b7324c4208478120f41f7135030984946f58843519 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:cac625935a0b19defeabef1ff069240d3f2f906982206a837e3e100d71775982 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:af576e45a8fdb9b9390cb1c9737ebf7242813aa3725493a8838185a4ddb24f09 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:3917b032782c4b2d606d2b22d45c6d86b9ea37b303159cccaecc9af3a204dcdb AS pg15
FROM technowledgy/pg_dev:pg16@sha256:d2dc1dc53be107cd704bfd375a48779c2cd75d46bc911037f37ce7c40d40bf2e AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.8@sha256:e5978740a590628f2114730bb942f35342ea70b8b7a86697a3df283c0caea109 AS pgrst12
FROM postgrest/postgrest:devel@sha256:a15ea84802a89d6256fe90c75f50545f0839359a548160381d5f45b5d14573ef AS pgrstdevel

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
