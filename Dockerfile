ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:54fb2a94a096e136d4b31bbaad26c381240299e41c50b5ada62aa2ba93087b36 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:bd04b109e6bc36bbd6c945a61e9b3479b05e3e6f5118f53388a6aecaa2178ed9 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:f902cf806f7861d7e8b3c26bca1aed1caea79e173b7de68d1546cb8f405f344a AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:1b1bd28ccebba1aa98abbefefebf7ffa134481fb8de4b7dbdc53b30d150fc567 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:5587fcd0c94148fb035dacfefaab962f8fc517cbb9d7240628b04f20165358fc AS pg15
FROM technowledgy/pg_dev:pg16@sha256:dd27a51c293824649d63bac26069622fc8c80115a03e675a0582fe1d40c45936 AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.12@sha256:5f4ce744539bbba786b4e24dbbd95bdb2a956dcf568c5374995a0ff4a68f5bd2 AS pgrst12
FROM postgrest/postgrest:devel@sha256:e1cc71ce03d273f4b035746402220a5586be57545e4a135eddc05d3bbb5ad8cc AS pgrstdevel

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
