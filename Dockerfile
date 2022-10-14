ARG PG_MAJOR=14-invoker
ARG PGRST_MAJOR=10

FROM technowledgy/pg_dev:pg10@sha256:c9719dabcb36182ddcad90e622339df5f33a3b3b6b417d6140f3b81c71b8bdd0 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:c8faa40555f5c40e1d05d0cee182a70f525490b5ee37a3b5cfa2393b66eed26d AS pg11
FROM technowledgy/pg_dev:pg12@sha256:6023ecd0d43cc38c76c2947c595359b77cb3774cfd3a6f6a737dbf652bbbb276 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:ce548b0969e41402903b416908eb102034859af7d4aa79b7e3f876000ebedf13 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:9a5d717cea57e3fecc04b89d40f68c1b5b616e8cb986ce1ead400370565a50d7 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:8684ed3ff3b626712ad4a026f6858881e5c8c3bd1ddd2b738387623ac446abf4 AS pg14-invoker

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.0.0@sha256:db9dd042f5a4f7528b09723e08434b1ffadabeec8079e33ff38ebd8273177100 AS pgrst10

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
