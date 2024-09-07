ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:5e8b4be27bf4557a1c7c823054b5aba94be1f147f5e01d8603db3671f3566f5b AS pg12
FROM technowledgy/pg_dev:pg13@sha256:4d8263f35d333a6e37c9c8f2b53017b50c17c5b8b574d4f445b809712ce0e81b AS pg13
FROM technowledgy/pg_dev:pg14@sha256:5912b086d7ebbb8da44792e7ead12aab520f3eb9f96788e3b49cccf57e419983 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:675f2832bcae51845ffb55db66d159deecc0d1e5c401bdc0d0a119aefdd2daa8 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:fa9dde1919776bea01a9d45a071b228ba6b20486e4ed08b9021c476efdfc6b9a AS pg15
FROM technowledgy/pg_dev:pg16@sha256:ad04ec6e2abcbc5b674c0d0993437d976430228178043a65adc9690e872f3c6f AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.3@sha256:729bf65c733b73f5b52777f0e4b853f22ed73aa67a22d38269d289779b0a8401 AS pgrst12
FROM postgrest/postgrest:devel@sha256:d90942f7b5fe79c8190565b648e35f12b3578882c19a8eb3059af03a4ad9ff99 AS pgrstdevel

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
