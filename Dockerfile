ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:50c015cd8c1ac7e6ae86b2e2f537dba2c89d89d593d253fbfeaedb054ce82859 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:7d21393ffdf8e35bf76d19d24c9a4cfc19f230c276a78a9b1ae76f80ac8a9f1f AS pg13
FROM technowledgy/pg_dev:pg14@sha256:49e5b2b100f46b4f28b3c736501e8eb72fa0d1ad3bd730225f2997bb8386392f AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:8f66bef5192ca22a67fa6cbc9b9dcdda4cbcf02021528ba37f890fdc2d6398d1 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:dc8c035e2985eed1dc57d758235694958a74970a131d76edb6b42d2d12629383 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:d36d9d51de3fd530a35c719bbdf29f8c993290c6b7f60c4c5bf0bbb217609f57 AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.8@sha256:e5978740a590628f2114730bb942f35342ea70b8b7a86697a3df283c0caea109 AS pgrst12
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
