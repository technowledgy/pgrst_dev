ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:23f40775d3361225bf82dc39c5ec82702f355a9365a4da953e218006c4526a72 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:073d118932f56b4ba966da34c5e3ae0aaeb419b7bc3f087305240976aa808cda AS pg13
FROM technowledgy/pg_dev:pg14@sha256:f2a2f9f430ef66ccce01b17db08033635c1b74af77f92d28bbfd5aab74f83cf3 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:e084b6d281cb0de843e4e98c21d9cb0730c72741577271f4c8b91ef6df307565 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:33d57e88239b3cabcc5c147d7a124c099fcc42450f8069716e10772e8efc3b42 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:76b6b444455b41d50ab50c6165ca5a8a77154d1bec92b0f26dbac643a15e781f AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.1@sha256:7991389d194ddbba3dffd551682601784cbb1650a815ad9d6caaaf07b094458e AS pgrst12

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
