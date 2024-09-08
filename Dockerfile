ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:d8907aaf580df65963e88675422914b239144402acb43f69794e0c68fd563876 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:4c1a6840ac241af57dc3c1ac4ef125f5f88a339ae5ee814399a4789f1ec563b6 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:956e620282ca2b2c0cb4d8294a860d083505bb5a1b1c794e5634bc9ea7681dd4 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:07e1a3631830c9337766f2e0d835c5ec22a3833c8819ed0ccc2aa63631d12824 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:3d71955899666de54e0599fe706bcd94feb8e7b89245e5d9b37a81731ea82283 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:0d34ea52ceb517dad19a4a9ad6b4767e8f36b9ed3ec083f72e86c36b0bc0ccee AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.3@sha256:729bf65c733b73f5b52777f0e4b853f22ed73aa67a22d38269d289779b0a8401 AS pgrst12
FROM postgrest/postgrest:devel@sha256:d90942f7b5fe79c8190565b648e35f12b3578882c19a8eb3059af03a4ad9ff99 AS pgrstdevel

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
