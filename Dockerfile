ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg12@sha256:9cd7682c09da91c84f76d17a31778bc1d1cd463c74221706ac4aee169458533c AS pg12
FROM technowledgy/pg_dev:pg13@sha256:402265853e34780e8ea81d088b986ae0d6bb2cc49d943507718d204ee0ce2582 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:e107e9d0994fc0dd194c59ffa92bcd8967bab83691d5bfdc5b10167e9de46a12 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:f6482eb6a79496aa8e751f099fc5aa8665124997bbca18344fe77bea5d6b60bc AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:e7f209f0c0c366781a46cc9365cb74f0c2f6ce186ee338e2dbb90d4f896f10a8 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:a5ec9dca0093adc30743fc871b232cf87f65b012e1b7db4c96289217e98c7446 AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.0.2@sha256:79369c0cdf9d7112ed4e327bc1b80156be11575dd66fbda245077a2d13b803bc AS pgrst12

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
