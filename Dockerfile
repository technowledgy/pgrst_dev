ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:a7335ecf8a2db1675198b13a6e239bb7fae0554a04d1442af7352e0d25c8b100 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:d1e9a8a750610e9e0486763225acbe605d9ea0d0929ee6959ec29fe48220b865 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:6d78614f133a5fc4c65f150b2f89bf053b52834947a276d44338bdcd76cc058a AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:0b768c8444493efde858238ce6c2d9eb14a59744051417b88508f8e18bb87961 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:4bf1b24abe14ff1919bb97a0f42a746e2af0e0d9285019dd28ce19503976437c AS pg15
FROM technowledgy/pg_dev:pg16@sha256:3b283d6a3047b5a0eb5404371c0dcd0c5878569512a698c0f8ef83e54bc814ba AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.8@sha256:e5978740a590628f2114730bb942f35342ea70b8b7a86697a3df283c0caea109 AS pgrst12
FROM postgrest/postgrest:devel@sha256:604ba3c0e1d4f8a9f7bf3f3a3b7d69c6765b0ee5e8b8c90ddbd09651baf4ca0d AS pgrstdevel

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
