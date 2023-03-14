ARG PG_MAJOR=15
ARG PGRST_MAJOR=10

FROM technowledgy/pg_dev:pg10@sha256:a5c60303ab37b62e431f6d92c6d4c287fc828b4025ad48561899884773b256c0 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:ded2dd967ca0f7725e54efb2a96584c58de5be14820f3e6bf12409a5510d3a56 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:a1975b6aca5bf5b912ce55507dbeb5c3c421c6c3336d916c610ac7f90dd12495 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:ffad82053072c4c9a4d7dfc76a8852a7232c727febb72552500075d638be06d2 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:6b50f4f004eed700805ae5c934e0383800c26146f15512baad6c6e770250ed4b AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:017a4f8b7cc0390bbee457046dbe1d1c3dd2b18309b1ef56fa347c68605e7716 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:f31da023f18189059510dedab94e560b148b5fe4baca83ada00fad21f1d6e078 AS pg15

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
