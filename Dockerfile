ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg10@sha256:dc82083d37b529fdd3450ab672dfda0e1d26c15ee940a4a6b4f42cadf19111d5 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:5e4af7b18c28b18d0973a76e38311f32beeff5c3a1e1fc43ec9d1296e41f5bd2 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:f60c3288578b8abf434640a989ccbb74b91685162c1f2f9bf8bec65036fc1482 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:392e80d36609f1324e080844660b6195d0f4bdad210516e3bc8a8e610ed7477d AS pg13
FROM technowledgy/pg_dev:pg14@sha256:cdbf5075c3144aa2b070c233ab834086703fcc22f086367e28e9a5965c160580 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:a61937c3337a25124840bb329c511697e2d10945daecd718480d878832f0da39 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:dc2d10b9888d993a561950953db57a5cd171a82527583166c7d63ecc181268a6 AS pg15

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.1@sha256:2fd3674f1409be9bd7f79c3980686f46c5a245cb867cd16b5c307aeaa927e00f AS pgrst11

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
