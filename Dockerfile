ARG PG_MAJOR=15
ARG PGRST_MAJOR=10

FROM technowledgy/pg_dev:pg10@sha256:5c71eabb825c9bb82e06213e90576566e0ab4be53c1133e2ceccc9201d360539 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:f11a66ac12be80194b0e6b3645e80e1fb0dc3412c27c1de33a90ec2504d485d8 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:aa0f8ca8e710a38132ed0a818234033ce04256dd27953826c5dac98fe9badaca AS pg12
FROM technowledgy/pg_dev:pg13@sha256:9a2c6b91b190d7cdab023af7bd39e03e8c5e51b3209d5846d54f5643cce97b09 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:3cce9244a7d006db622419b8f6932f87ec9dab334f8420590ef737590680e9eb AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:f60f33301ec43689eae303ce4fad8cb7e4d532ad2b279d66544ee1d11cbf1a9c AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:eee61191e0c6f9ee5154a4fc97c634c454306451fbfe07fe83fb496e485e7fd3 AS pg15

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
