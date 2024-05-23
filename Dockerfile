ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg12@sha256:4c755eb4c8c73f695e0f5e0bfbcca740aa7b564f60258677251d5c9c0444fe2a AS pg12
FROM technowledgy/pg_dev:pg13@sha256:07b18c8cf8e2d06097fa6d759586b73fe3095a5a787348b289d2d857257f0b42 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:992a1438a387ab755d5dc3fc8f916a59dc6039218aa9e2bcc1688d10c4925cda AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:06658f1a8975331d88653c9dc1a26eb606e910e1ec46742b48045a4051cd71ff AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:0ac2af2fe63a06e08052f8e8f78364a0db06f76fb21950b0d1aee3a4f4d54f0a AS pg15
FROM technowledgy/pg_dev:pg16@sha256:8a522581d01f04d595e1c61485055484fb55c4bf21dc572577158b197fb0865d AS pg16

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
