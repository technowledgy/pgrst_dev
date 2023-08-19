ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg10@sha256:c52d1d5913f3feba6b2072837df3d38a2ad16a44c8f8c095963579bc477b30c2 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:910b797044f10279f283ebb55c5734517cfc934bc6787b46abd5fdd67a141d3a AS pg11
FROM technowledgy/pg_dev:pg12@sha256:a1f75716ccdcf10728e28cb9497ab434db38e91c3e756a441e132e927d1117fd AS pg12
FROM technowledgy/pg_dev:pg13@sha256:78d41654029db021e50090b00c30f4c35bbadd913721a86b0c48a66ab8a0d16c AS pg13
FROM technowledgy/pg_dev:pg14@sha256:202892ceb009aedcc4220e544d5c3826800081e1333b7a68bea06ad2fec01503 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:d0d6019ab6ab9fb43f81504e44ec0e04f1938c8c5007c58257563905efce1e14 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:2b4b62cf3b76ff1e98e90e254df4002d6625743b562362d5071c49eec102896e AS pg15

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.0@sha256:5cb1228f3d1fc6f3d0151a99180d11b38488c9dd7a2eafd95e9e309d3c2fd9e8 AS pgrst11

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
