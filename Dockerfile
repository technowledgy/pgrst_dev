ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg12@sha256:f18db1df919642a3f70173d5f5b293d9f0eefbb94e0f0d0fdc39a745f2769943 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:4ab1b5b30f0d68de3bc41567bdd0e10c16cbe3f55f7bd9b1a7a9660eb1a9d31d AS pg13
FROM technowledgy/pg_dev:pg14@sha256:2cb60f97564b00857e101ead0559c1e19f1e2c8a222485224b18de9ce4189626 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:5072c20a917d4265e11015f296680b474fdb9ff0f2e04ac35783094b0a16b863 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:0c12baec4899972018d1f9662b5d8eb26b4b7745a163dd1b84d25e15be458a94 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:d746d08aed02f064c60774f7d7f8b8b6ca25e33e34d828c3d07b13cec77730ba AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.0.3@sha256:25a7e698337da07976ea830fda7c513ed2e907094337a9833948fd30d9f77a06 AS pgrst12

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
