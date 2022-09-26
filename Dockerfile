ARG PG_MAJOR=14-invoker
ARG PGRST_MAJOR=10

FROM technowledgy/pg_dev:pg10@sha256:5df52d4d521e4366060d5c1649fe51b619e919cc64916c485f2360f441fa3260 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:ccb3da44f67f1482766f5f4560f9ffc7dffb0cd1582c183bbae1a8379df28cd4 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:9ec9dd88d74833de16e866ec98033920d78cf6081f24365b16ddce46ddd85eee AS pg12
FROM technowledgy/pg_dev:pg13@sha256:a6c418aa58f371685c7681e20ecc49531f1e6f3416446a4ba2e74d93838623b0 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:2aade2421fc23d0dedcec0ba93d418efdf3268587fbf8c80f9dc73945b4a3d81 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:dbd79f734677a109780466d7ad5c2f87921edd7c44fe91da5e21e2368a34a5a9 AS pg14-invoker

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
