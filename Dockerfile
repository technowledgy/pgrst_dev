ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:2a58e62c2ec04747aded6d2cbcf70a71ed47cd30d6fc46e95fbe42dbe5acb0c2 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:58f3e7edbbd6658b3134b9accdf54ed66e9ba6306f8da73863c044af655427c0 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:cd754ffbe47b40538204c4776fcd4142439a93ded130f5354344769746c8b926 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:746132522105032f94cfd3940683373746ce52b3eb66efeb2dd4233f5737ec4e AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:bcf4e2f01907a86fd2b9a45b753313afe30e942a0e21e72d2c6f274b8678ed9e AS pg15
FROM technowledgy/pg_dev:pg16@sha256:4ef95d5e1ef8b7016038b9eb18e849cb1cc47831917c8b36cd135f70d5de8f7d AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.2@sha256:7755805562a33c0359c768a87d43f2ef6b2d13621778d43d15e12437c83f53a6 AS pgrst12
FROM postgrest/postgrest:devel@sha256:1dbcafd373569d0a37c186ed6149b896de01f5b1027242572580d2ea53e15c59 AS pgrstdevel

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
