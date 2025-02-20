ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:8a7440d2bd32c24eaead0ec2f4e70a25b12e6b5b4717675b8bb820b95047aebc AS pg12
FROM technowledgy/pg_dev:pg13@sha256:83fdb9d1e59cbd3e5ddcc6c36a775e4c357c3bc7ed589180d4a289e4f2308930 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:635a5e585378d05bcdd58b587402ea575d2358ccf5c0d81a908977d8aec96a58 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:e4d810a4169226c180ea07c6bae34bf2f88c481e8f3d235a8b54c6c956ab18f2 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:39ef9db03b84f6a6b4dbb88ef5ef9044902e08434f6910cba07a8f25275413a7 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:a7990a65702cbf631c8997b4b96ea6b509e828ba24cfd637d452f945a36302c0 AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.8@sha256:e5978740a590628f2114730bb942f35342ea70b8b7a86697a3df283c0caea109 AS pgrst12
FROM postgrest/postgrest:devel@sha256:99baa2e25184aced60085df3c62c62bf301c5349ae8a304ce120acc020f447d3 AS pgrstdevel

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
