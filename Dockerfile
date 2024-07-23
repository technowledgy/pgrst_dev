ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:96e10aedcf466cdd485d0fffbab3358db38dfcc8249e971108fbb5d938455364 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:de0b89385050ff23aabd033c7f9c44bdbab1f444d2163cf246be743ed4199c3f AS pg13
FROM technowledgy/pg_dev:pg14@sha256:a4242d66e8e3be432ebf2c23c33123786e07cc6aa4c050af5610401c96c40606 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:59f3a24970c5bbd3301bb53a213037c9254e3a0f93b813138fad34d0639bb3dd AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:d3a333b8d2ef4f579be69a20a92ec1e2eaa166371ead9785fb9f8b6d358cc268 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:ea14770074b6119565ff04018b0e90560be175cc2146c60658019f3279e47442 AS pg16

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
