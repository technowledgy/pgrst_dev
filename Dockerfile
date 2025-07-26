ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:2c3a91b4cdb7d32c444a54931d2b01086769a4ef78aa45c370a81d99d8668cb3 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:6ccae4fb2afd0acd087d0c170c01ee048e52f77d2b49f5fbd2a4c7059bcc9779 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:6067e9197ddac04dc768782209eacda115aafbae2409e10bc74242d4ec860af4 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:2861ebb717b90a0fc338461d7b3eb6295023743f792ee91bc08766396c5c2687 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:37866b74b0d20d0ba58d076f440f282aabd18f24ee7236dfd58503e22ac6758c AS pg15
FROM technowledgy/pg_dev:pg16@sha256:5e3ac0824ba24d61c2822f7272940043763f2d24a057c46b3f1ed023cca58a92 AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.12@sha256:5f4ce744539bbba786b4e24dbbd95bdb2a956dcf568c5374995a0ff4a68f5bd2 AS pgrst12
FROM postgrest/postgrest:devel@sha256:71dd1f2160ad871a34db8cda18d96352105dc1bc24e0b35e034ba0a94497ea90 AS pgrstdevel

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
