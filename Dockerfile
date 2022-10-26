ARG PG_MAJOR=15
ARG PGRST_MAJOR=10

FROM technowledgy/pg_dev:pg10@sha256:8363582d7fc6dcb6ffd58e5f2cd97c97a6303b2c78eb8532a488e866343be651 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:a58bbf472eb70c95949eff88677f63b74521363f27eb3df0adf8ef083981edbe AS pg11
FROM technowledgy/pg_dev:pg12@sha256:d577931997bcc80afbe74eec26bb43e22936128a6e5061478722c0a91d1be135 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:9fc22ff7afa32832e05c9feb98de93c9ec77ae3bbb4cd786fc6214a2c78b5be9 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:84b460792d6337a2fbe0e0e908a5aacdefa574605f2cec4dfbc0ff46a450381e AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:f832ccde7115543fc47e66d6fa8dd995b81fa85609c4a4bcbedcb6303ae269f7 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:f5bbe375d3fdf9721d38ed5e78ce8c8cc66afc3b75516ac584b8662b6a23ec87 AS pg15

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.0.0@sha256:db9dd042f5a4f7528b09723e08434b1ffadabeec8079e33ff38ebd8273177100 AS pgrst10
FROM postgrest/postgrest:v10.0.0.20221011@sha256:3697575a56cc09460b4d212c78c799304f97640eb6bb3edbc16959b2546b16fa AS pgrst11

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
