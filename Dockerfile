ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:7ed8aaf46596f8203ef3e748f543e3a57abec46e0a54d4a83746f642e492ecc3 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:35421589909bc4c0dcdb7bc8d268d24f78a4fcaeaeecc3b7ff5a614cc59611e6 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:72f98fe4afbb53ab903c37062ca539a61e4519789375e008086e92021517c1a0 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:33e5b27c56256ed2d5bae734eb8cff3d7991215b89612dab47afb246a3f04da5 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:ce80fa399f81c099f671a8047bf1a2cc109b35c2f0bb94a59800945d2cdbdeae AS pg15
FROM technowledgy/pg_dev:pg16@sha256:fff1f4e86b45efbdadc763223898c106bd69806a7927355e974f0ea199ba7bc0 AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.2@sha256:7755805562a33c0359c768a87d43f2ef6b2d13621778d43d15e12437c83f53a6 AS pgrst12
FROM postgrest/postgrest:devel@sha256:0d9c05c391a11fab97cf4010315ef4f1c2995c3b0a7521e52989c6a8c2148d6e AS pgrstdevel

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
