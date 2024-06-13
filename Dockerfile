ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg12@sha256:e41b38167d9c79bc4adfa8254305c586dedbece5ecec9c567fa0b169e9971d71 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:9a5bbc3d6f12a672aeef4fb51e4272ad9ec71327b1421f6361741ec76e0c3f35 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:953d3c058e89279c04fa30ff117a3f7fd3e26d4872dd7fca5c60a2fd043e237f AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:cd1905ff98328f6d0c9b21bf346702cda02a11e1036952bbd2dc1f0dc9405bc3 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:0936cf76ef0c4b9ca0ce039d0225c42c33e008e9a124894d7f675d3a100ff0bc AS pg15
FROM technowledgy/pg_dev:pg16@sha256:92d82d4a2a5d9ac30571cd2c8710ee08bd6b3552a14d354e64ae86b9d748d2ae AS pg16

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
