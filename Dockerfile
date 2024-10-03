ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:31657c6da6bd689599564ced2ddea60144e7efa43d9238e79240cf3159e6eaf7 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:7d4611f3709a2f3b2559e4304fc851a01b90e14dd8b6f9693a71324d4185121c AS pg13
FROM technowledgy/pg_dev:pg14@sha256:aa12403f94e6e9d0b4b5ab1d2fb7d4750a06846750582217311f04e168eff69a AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:109fac25f1e3d7d816d0f37a46a8651e92c0a4ca6805b82949b2f1ff91f10b2f AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:1bae0556318d9b17a38543ba2e2aa0041b539a65696fc3ccef0c350b8a8395d8 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:b39c4049defa48b51cafc612b01535e159a56a023a3f7373349a0b7b6ce7cc44 AS pg16

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
