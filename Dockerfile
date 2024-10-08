ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:ff6b89aa48a2a87c3be6abb07cd8bd5334805ae72bc1451283cea847db37c0e0 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:4452d856fd085317cdfa3592ab6d1413960021f4ee2e194d329291e4b9020e86 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:37e18f799ae4b3c067b3ba037c73f36fb9172ccdeae6c24c065c26019c503851 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:bb5a3746ba9e20455cb052ca7859a1632afd647df6fdfdc098d62fe00323f86a AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:8d2089871be9d956613b84231fabfa4f3abc8cc40bc4bbd285d27fa21c17e685 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:abb3f5cb33af6edb4dec63e3ca9f89147fce831485cb45aa96f2a76f229df401 AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.3@sha256:729bf65c733b73f5b52777f0e4b853f22ed73aa67a22d38269d289779b0a8401 AS pgrst12
FROM postgrest/postgrest:devel@sha256:f22b783cf1a55b60671508322104c1aa41c195f3ab0cd73e8ff4b585ade9a64b AS pgrstdevel

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
