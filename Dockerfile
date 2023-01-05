ARG PG_MAJOR=15
ARG PGRST_MAJOR=10

FROM technowledgy/pg_dev:pg10@sha256:839557406889613dcefc506ff01d55a6907aea6d495731ad9a66f6c9cd30ac3d AS pg10
FROM technowledgy/pg_dev:pg11@sha256:5cbf4e44ba25494f639e4d47ed1fdbba880dfdf91e3e90cbc15817d8b2c2c1cb AS pg11
FROM technowledgy/pg_dev:pg12@sha256:0cec715aaa9cbbf81e34cb3da8a880c04303e199fecc3bd8a81f77de5b22884f AS pg12
FROM technowledgy/pg_dev:pg13@sha256:977bb48247f02894f9d907570759a51a1b1936527305c52e413067d800ffca3e AS pg13
FROM technowledgy/pg_dev:pg14@sha256:77e84c0c05ff9f4d6ac79d7183e07ba2835c98f92e6935f5cf890b5491d6a037 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:d9a6fdbd3a8ecf776b2af0c3687823876e7b870f611d59951b62076a5e7bf656 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:13207aafac77286b16cfce2059beba3a8fef49efb58ffb45ac503f532806203a AS pg15

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.1.1@sha256:93ef9468e5da753fdf181b0968a0527eaf8de91231804269e4636e8c2626a6e5 AS pgrst10
FROM postgrest/postgrest:v10.1.1.20221215@sha256:a578e057ec58cf599293d9755185ad7c441bd7d0abb9f1f21d0fd116aab7f392 AS pgrst11

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
