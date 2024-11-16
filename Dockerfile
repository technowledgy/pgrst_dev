ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:cebafcd1febcd743cb2553759e6ee3a98206a54870cbc3cece45de9545e9e02b AS pg12
FROM technowledgy/pg_dev:pg13@sha256:ec7d9d22714def4be7604b395355beab0c756ce5f375268ea8d3ca42a1aae143 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:bb3e9b5ede94235f927e1a868fadd211bdaa0b9f908f1b977583ef4ecf6e7956 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:3e13c55389a686f32238d27022f37603e3c77edab58b569eb4eb0361c32bf313 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:1bf9c5ebb978a3e716030dacf68943ad670db707348d3d5460b145fd288fe2ad AS pg15
FROM technowledgy/pg_dev:pg16@sha256:e211ead1438851b76f6f6c9139c1004da1616dd751948656429bc8f6cdb4ebe8 AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.3@sha256:729bf65c733b73f5b52777f0e4b853f22ed73aa67a22d38269d289779b0a8401 AS pgrst12
FROM postgrest/postgrest:devel@sha256:426f8196e2bde5a0a7cec87a5a68e1fc06062590cbdfedcc8baff5536967b405 AS pgrstdevel

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
