ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg10@sha256:be65874877ba774af8d2459216cf6587cea192dd27f933d1bf4ecd34435c2897 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:d99d23de3e134feaf31a8d8116b11bbccb39075b6f61395b7968125d7e11f85c AS pg11
FROM technowledgy/pg_dev:pg12@sha256:8b5fe8b55dbdbf5cff8358ebc965578adc638cb5f31be51a2428cd54ae7988f6 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:1a822fba40b052ec8ac04d2f9b7a8e968f0754182525855c737b36bfea9df4cc AS pg13
FROM technowledgy/pg_dev:pg14@sha256:4a688d82b3e046fd1d4ac0f56bda7dffb4abee3d26086249598f884d9d9ebab1 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:d203eb53bb11888cc7a9f2a69317a376363682ce22432b6ea6b107af35d962f1 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:3b9e6325c76cc64f49ab6b36b25a60ccacc39362ea7952b379469eac17fd7b84 AS pg15

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
