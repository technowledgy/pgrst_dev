ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg10@sha256:c23bc1e8d7a740523b01292d0bdb9e762a42bb7f04ef7b62805d5bf26eaafc1f AS pg10
FROM technowledgy/pg_dev:pg11@sha256:61f2d3b6d2a28438025fc35483b61628f36d01a7b077d5284f77e96951d1afed AS pg11
FROM technowledgy/pg_dev:pg12@sha256:33b03817e48ddecb6de5b14b671236e478fd627d142ac34743f7413f8bf40472 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:e291807c5148357ec655434b8ae0affb9c7ab95e56b149b1c7a16fe923926313 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:84b1810864b1370e4067d324bd644fae44312cbf9f57d70a9cbea66a0623d2d4 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:df9e14ad48b0e2c1649d6efa699345af8ad8e00a122025010bbd9f1b89d06ac8 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:db973d3e5a4a920bb83969af0e840c1669b5257690df9b249fdff81fd4e36604 AS pg15

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.0@sha256:9a38d9565ab92675e0ad5db8e2a24f8aa2d2f98accb07a517a61e598edcbc98e AS pgrst11

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
