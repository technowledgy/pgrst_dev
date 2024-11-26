ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:bc93580410ab1afd2ed31e924a5d9f0b72aa50fd240f2f0697337be00d6b9648 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:379e319ead168b0deb3bebcd340b6c522ff352ff66a8b6695254f98e660567e0 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:a3090dbafedea5e97b612ae578f6c33080518dec501fc90ec55a35ff855e8eb6 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:b54f750c4c0e288b37ac9cc5c9b3b7565c5e330241aba7577439119712d827e2 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:66e8bc1bb1fab59a64f207a3937ac7a24d0553ceb38faaf48046484654fab2ec AS pg15
FROM technowledgy/pg_dev:pg16@sha256:c6bbdf10781ff7c799779f46ec7651f623d7705245b1ef8ae787294e62ea20d7 AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.3@sha256:729bf65c733b73f5b52777f0e4b853f22ed73aa67a22d38269d289779b0a8401 AS pgrst12
FROM postgrest/postgrest:devel@sha256:f9c262da9d632b94125f494c55ccb37dc692ef573a1e1f624a6fd2a4cf96f97d AS pgrstdevel

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
