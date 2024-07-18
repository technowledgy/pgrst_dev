ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:aa7262e90ad8e617e8ef7a69a7fa480e90e55f3480743501c986065f063fbf0f AS pg12
FROM technowledgy/pg_dev:pg13@sha256:7357d83fe10731ea3bf62a4f48681a6e7047aed9f3808beb94931f5a8656ab6d AS pg13
FROM technowledgy/pg_dev:pg14@sha256:55e022dc6c7f1f7818107cf7a7324f667055e0d627a5fde927d01d7e8d2ca794 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:d0456390cc2728164f7f21f811507dee3bd7119ae8fb68ed388fa754dc618c6f AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:f905d84c6e9b6f2783235beadcea40e2d2c13d405ddc03e70e5376da18ab69e5 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:6852fede8a4e2c3c68c01ae05cc4e3d2fb65bc5f6bc7d08bf848ecf3b78eb939 AS pg16

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
