ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg10@sha256:7b418e40a3c3685373f9721fe59f576520daa5e461acf5e28fecfd5150aa0a2e AS pg10
FROM technowledgy/pg_dev:pg11@sha256:623c872d5ec8cde8d86b5ae3afabb46319175bcab414e0732d91ced2a46ab652 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:91d8555eb71968ac2e325596ab728e8b5ed2af760b04c61ba62faf098c1b620d AS pg12
FROM technowledgy/pg_dev:pg13@sha256:6789813d8890d5fbed78ba6b7f61961ca109928594852784c8f06b6145c970ea AS pg13
FROM technowledgy/pg_dev:pg14@sha256:311cc547e1de86b95168c71f60ceb55e865062f3cd6885397407d6e5436eaa18 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:a4af3770f21f9874393f5f718dec24c30be80d2cf55e7fc5bbadcf33100c25b2 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:f7dc39fbe55225074476b4cf90e63bd1780eb5b4154702609df0010be3132369 AS pg15

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
