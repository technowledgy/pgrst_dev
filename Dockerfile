ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg10@sha256:842664eac4f074fb0be4a985626985d9f343e6f54458abea6721ddd7e3f62fd3 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:b795ad2cbf7416adbfed3924b65a80e5acdbc1bac731e507554248a45c8a7711 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:797a3dbbdb6d83e90d7f825a1bfcabfd3cc3ad26cc7cbe73783c5317c1e537d8 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:9d0d91523abbb00e6cc0dde334d5fbdb43ad6b1f8540d234adc32f178ffefda0 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:a8834358f680be3eb1dbbfa2a0fea837ea627c8462dd11b1e3701be2e3db5223 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:86c27f4ef8f4b16cb98436358e60fc16f1e27060ae4b6ced0e1e3e7717f6a619 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:95e59b4dd6598bcbd628d27d6dedef9caf9a7f24e1cd4039ed8a1809725dd74a AS pg15

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.0@sha256:9a38d9565ab92675e0ad5db8e2a24f8aa2d2f98accb07a517a61e598edcbc98e AS pgrst11

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
