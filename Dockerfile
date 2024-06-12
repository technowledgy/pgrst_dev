ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg12@sha256:d5ab71051046a37222034fc720a374a470f9d5eef6c1446f73426fde31089016 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:b882e6681074dda9a94f4ff6fd24df682de0b4fd1c0abaab6e4ac72842762195 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:f68824a419063926931a5cbfddd3cd96db17907d6e799ec715734439d3355f19 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:13b2d3dd7453db70f1a72a48980aac7e902c77f76af7b0dfe09a4a7bac673c8d AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:0936cf76ef0c4b9ca0ce039d0225c42c33e008e9a124894d7f675d3a100ff0bc AS pg15
FROM technowledgy/pg_dev:pg16@sha256:70ed75cf2bf50e850e14e93ba91fb29505c8d60a1ef375470570237a8749380a AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.0@sha256:2cf1efd2c9c2e7606610c113cc73e936d8ce9ba089271cb9cbf11aa564bc30c7 AS pgrst12

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
