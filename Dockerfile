ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:bbd52e14b20cd46147c540d90cca5644ce9d139ea1b4da2483694ee12c85b1b4 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:43432446f48f548469cc460e402c9ba6e1e924f9fde415e675a38f960b793a51 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:911173dadebd99a6cd9e8ad97cdb3433a150d41f41563050d43602278ae76d06 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:164a5612e613e968d0ebed84fd0dd825ea3683d90f2e0ec2fe09abd36184b44f AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:8f77d04aa2ebcc046a43ff8d62b74b9f765aef00c7e44d8804827ee2252e3dde AS pg15
FROM technowledgy/pg_dev:pg16@sha256:34053add021e068a6693f62b83bb2e9d4bd11ad99d8ff243d99f72f51835b4da AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.2@sha256:7755805562a33c0359c768a87d43f2ef6b2d13621778d43d15e12437c83f53a6 AS pgrst12
FROM postgrest/postgrest:devel@sha256:0124c23615f789ceb1691c472d451a1eaff8a660a531a060aac936c6b8f52774 AS pgrstdevel

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
