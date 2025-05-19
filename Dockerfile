ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:76d172a20151bfa351a480cfa324112eb376e387913e3bb72a401c99556913c9 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:5c9007603ebabbe0223979551c89e91f39e7dd14985d1002d92759e352c3fd45 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:702c469c845b6080c8e370ee2558314dd74b04082059d6f5a6cc91d93bc045cf AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:12bd11849c8eec41ffa818d6c4559bd4a322d5a86de540de443f5d5b6a3a11cc AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:46fa0c7e7e67d55240aaff9a0034d6b95a026cd92aadb5ea4acb42437c1bed5f AS pg15
FROM technowledgy/pg_dev:pg16@sha256:7ece28e51601f33880490dd75efac476f130e36bf057b24a598966fbe51759d1 AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.12@sha256:5f4ce744539bbba786b4e24dbbd95bdb2a956dcf568c5374995a0ff4a68f5bd2 AS pgrst12
FROM postgrest/postgrest:devel@sha256:547694f85963f257cd54a72146d91d8583cb4c0d690e1bf17f9710325b75680c AS pgrstdevel

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
