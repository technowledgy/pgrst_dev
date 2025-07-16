ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:137c8802c0ee37ccefc63b61f3d12482d17bbe52338b8726055cad002598cd36 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:2da2a20ae3617daa15f5a328f32615c93046e55b16091a35b549cce72c468765 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:8d418e7e5ff18293ade1de8d11099fe9bcd98636b920110388356283fe6ab54d AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:bb680d78c4c4f55d8b9fa872a791e0a6d2e2e9c6979db682ca842f6f4fe4f79c AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:875fb2ba6677812bad1410e8aba0468f321fe04434cca3bd9c695a5400d59b22 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:5894e9d7c0a1b485bd4c63e126f68dd4856ef4a736273f0427fc1928223aeec9 AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.12@sha256:5f4ce744539bbba786b4e24dbbd95bdb2a956dcf568c5374995a0ff4a68f5bd2 AS pgrst12
FROM postgrest/postgrest:devel@sha256:1364be90cae86820c99b022e37a05dc628f4fa3fc55b5c41971e6cd634c14bb6 AS pgrstdevel

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
