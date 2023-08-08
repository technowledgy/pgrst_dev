ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg10@sha256:2317ca30e0db86c0931e90727308624bbeeef8e243ac746547693ff21aa570da AS pg10
FROM technowledgy/pg_dev:pg11@sha256:83b86ffdb776820b7bb70c3f618f6306c510af273072c0e586fb56d47080ca63 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:0cf4121eeff55000cce9012265487faec727e4f6243726d0502413facff938c7 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:c147658fff96823ff196fbaae1d65258945c83559adaf9231d3008ad4d2ce83d AS pg13
FROM technowledgy/pg_dev:pg14@sha256:8eea8c07a2d5c6971c0294c9f42ef61b636b0c537f3288f2dfba749d390af112 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:c657d936489ffbba328038a2e92c9f2607e2a81a72c615c62e6c07d0c0c15833 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:cc3d5dfcd32f971b781bbb17b0c2d10001fba42d0f5c08be88fee490ff421eb4 AS pg15

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.1.0@sha256:53acdb91a92d31d17020b6f60dc34ba47c454827cb59f814ede01fb539754247 AS pgrst11

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
