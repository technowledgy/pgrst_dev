ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg12@sha256:12dcaae1f44fcb45b39e8c38d07c5edff294e34901e9237c93c5af489d84e548 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:333a2d9d6cd0aac23afa17ac74962596ff950a4f3ac5ba688510f815a0c839d7 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:3bd37be4b55a3ae0487d6bdf3ebb025544646e3c14b5f7b222d0f9467d89e0c0 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:29afad31280343b188ad0fca84fb869bae13af30322c22be78a2db116f7ba5d8 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:84b1d9048d033fee61555edf800b6a55615a470f849e943dd01c49b01dcba716 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:4b659a77ce6aaea5abba03a84bb41130e00ef560655470ebaa12604c52687c99 AS pg16

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
