ARG PG_MAJOR=15
ARG PGRST_MAJOR=10

FROM technowledgy/pg_dev:pg10@sha256:de4a7b541d2b8a663f01ceb81fad44f1474907ab711453a3ab0c93fb7693680a AS pg10
FROM technowledgy/pg_dev:pg11@sha256:54682b15c6c3e3358a60790dca610750c2e49741b63030ab1c66dd38c0b1cc19 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:61515014d91f87d7ffa7d05c0407b988d848758f7373df49f1a25be50fc3c030 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:edd089fc1dab1b4e101303ad501ae55e2db7c8c6db3688613e8e25f17cd3dcfa AS pg13
FROM technowledgy/pg_dev:pg14@sha256:da5f6b9db2983e49c6de604ffaa5a97425ef480543466d0091f4e1f5171df940 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:5c058797cab8a9519ed608ffade173e4b6fbf53b7f250c947dfbf24177100972 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:98785ba0f7f0a1ec1019b43951f3f543fb772619cfb697d2f920552a208135ca AS pg15

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.1.2@sha256:058d34b648f80f7782e1e062df13eb9b541825b38a6b521f3848af86c85be26b AS pgrst10
FROM postgrest/postgrest:v10.2.0.20230209@sha256:cedfaa2cdad6492d8f757cdfb989e65e115f5b61a97c184909dca53d8c5b26a6 AS pgrst11

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
