ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg10@sha256:96c37dad98cb6f01e74530cdf3226c83d2b4dc8fc24348f25af4d5160fd1d7bb AS pg10
FROM technowledgy/pg_dev:pg11@sha256:61eced40f7e3caf7cf0f49f455073acc1d2d7301925c38e0bf6a66bcf0963003 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:b8a82cbb6eebddf47e2b4902fbbd2386a05a8f9541fa467101a48ade74b9517d AS pg12
FROM technowledgy/pg_dev:pg13@sha256:79aaee49537b164e7228f8063d1b81dfa6686913d44fef1a2958cc25082a3654 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:3fe5b11b96296dd8377b29e1ee0b76776cb5f7c87a38827350c9dbe4b59e5e5b AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:69956cc86d8dbd0dac8cd1964969ec69ffa531f2c8be4b9f90c7a74198b0d2a5 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:5c4e2894526c9bcc28e78884226296ef3ab189f8cceac144288d3f13f0a5cb0d AS pg15

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.1@sha256:2fd3674f1409be9bd7f79c3980686f46c5a245cb867cd16b5c307aeaa927e00f AS pgrst11

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
