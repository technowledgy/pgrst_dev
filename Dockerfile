ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg10@sha256:f9e75143d9cfc615a1c0c6522104eb1c851d6922848429ee3d9ed06818c71a1f AS pg10
FROM technowledgy/pg_dev:pg11@sha256:0f3f9d6cab2afc4568daad25ed62b2050e3180e3bee09ca9767a68dab76f10e2 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:56088c94b5443382be1eeefc06a9ebb8e855934d5635a0725ee444cef680ef26 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:bb5e3387d089bf7ab5ef5033fad2c522912d700661b722d4ea1064f2d41258f8 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:d4a1e045d6d740e4637d547ae0512d57b47e7473011d51797d5d1b237014e952 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:9f25d17e0f73a364e9286f585aec05df4cc5e01955f00ccabc561f832527f1fa AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:9f30cb7cac944b140f2f27c8975f3d958d8317f00d4cd3a9876898f357d675e1 AS pg15

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
