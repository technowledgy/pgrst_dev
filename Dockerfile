ARG PG_MAJOR=15
ARG PGRST_MAJOR=10

FROM technowledgy/pg_dev:pg10@sha256:288d6ee01ce20243e5bb56bc3b4a9d3140d3dfe8388a781cb6b208972540ca79 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:f72a5577de2261ae174797443aa5079d775fea76d34e1e0dc781392c92d87f12 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:ba6fde53a7ec31a0d7922335834edd48608f99a2daf59bc5de7330bf821cbd63 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:97708aaf7589632ce9b6f41e70a688ccc0316b692742bcb83982f2588931e334 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:8d99b2cd506a404ebb6217dd20bce98481733b892f4647892378e73bbf968784 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:7eae0a3633f99638c9c381b18091db575808e0aee9c96ba5c03e8c86ac13b8af AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:b057613f4b6e7685edff089c8e3b5224318e822673eaa32b2200fc9447b30567 AS pg15

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.1.2@sha256:058d34b648f80f7782e1e062df13eb9b541825b38a6b521f3848af86c85be26b AS pgrst10
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
