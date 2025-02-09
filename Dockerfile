ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:49057dcde86f3dc62f0e3f348e935fb633dc8acb3aea1d3607c82ff28e801f8a AS pg12
FROM technowledgy/pg_dev:pg13@sha256:81b4453a268b0de6b6a7cf0f46cb5316c1a83d7393211387c50ee287e6a7ceef AS pg13
FROM technowledgy/pg_dev:pg14@sha256:5316c72cf4a4c620f419163986c75ef5d6961d07e3216015ea6f8b4d9dbd45f3 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:1098ffc0183a09d6638a82d9411930f246053c573e1ff2fc6dec59f45924f7ab AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:e393a574934f6868aae18ec597efdc536c7151a3d3c6a4b146556428d515608c AS pg15
FROM technowledgy/pg_dev:pg16@sha256:bb1dffe7c914b0ddbc6db6598763d5d914b3c8ce31a5aa446f02017a6e4946d7 AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.7@sha256:65d7b9d425c86e05d737302e3f434579df54e13a29b1d2161c850b05b9aeaf4b AS pgrst12
FROM postgrest/postgrest:devel@sha256:03eca1eb1a439a8a36bccbc41b5a9cb6b755e45dfe87750b801683a9d4bb8115 AS pgrstdevel

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
