ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg10@sha256:8ac4485d90a162a1598ac47650506e2a2079ef8125ffc98c11c1e5217ae9479c AS pg10
FROM technowledgy/pg_dev:pg11@sha256:7e82e93ffd7da31bcaabbeade2365749be368661c3970d6082f50b28a1f50a0a AS pg11
FROM technowledgy/pg_dev:pg12@sha256:6e365c473d44a41d4d75a336f661b4932ab599a0a6cb7c84cb643f9076f39c98 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:766b4ce016bf7892e86538399aca3b7b216c8b20ad9961c531062a889e616a0c AS pg13
FROM technowledgy/pg_dev:pg14@sha256:167096311c6c34d137b0d69c97f89ef1ead83a5e8a8637d80e47a4f0c82c095d AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:9e68e4cc802c1515a67b7aa8f4a344c1dc4b3f9d03b380814534a1139e1db67f AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:cdcdb7c5d074633c5ec5215c5879931118cb7a01911a15e11f850bb9761971bb AS pg15

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11

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
