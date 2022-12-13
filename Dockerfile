ARG PG_MAJOR=15
ARG PGRST_MAJOR=10

FROM technowledgy/pg_dev:pg10@sha256:2de6dd8478e1cd850a5addea1402686b57073f996537950c9a79a0c365fafe50 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:2d5fa36a12a15804bad2a1f7a754d3b496ef0d6688913012c21d2e73fe520a6f AS pg11
FROM technowledgy/pg_dev:pg12@sha256:522658922602459a1b139189081b403adbf5d98c918a1befcba004c3b821ffac AS pg12
FROM technowledgy/pg_dev:pg13@sha256:205d015173ab762c8580fc66092df2a266b2d2e9d9ca2031ec01d5a13017cf3b AS pg13
FROM technowledgy/pg_dev:pg14@sha256:49c6f82d02fb12a485176a3e76e0a58e622e5a7a8ffd44cc72053fc12b5902c2 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:d820912e22e84b474691b2636cefa7594a2f3df10b83434fdb57d76113dc85dd AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:82c9499b9b120d0e5a8dab4788a1271f54a53f8854d5f800e96923954067852c AS pg15

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.1.1@sha256:93ef9468e5da753fdf181b0968a0527eaf8de91231804269e4636e8c2626a6e5 AS pgrst10
FROM postgrest/postgrest:v10.1.1.20221212@sha256:e6809059cba6cebf9efd3153d68496f7429ae0b8289eeca4fadff81b4088997b AS pgrst11

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
