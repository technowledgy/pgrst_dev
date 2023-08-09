ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg10@sha256:155ebf50e3ba44526b91cfe8acf8f1e9e71fdcf0bd46b68856e14d89560ccf9d AS pg10
FROM technowledgy/pg_dev:pg11@sha256:2c64ba1a25353f1ce847d2f5ddf41c8ca46b7715a566e75890f6b93e01b33194 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:a9bd04307a425b82b9fec63fa2c8d491e1c2377bf9038d3715539b9019e67987 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:17ad9d5f37d071f8a29b983864641385afe6f6077311245d1da2938b3d16dd72 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:e8ee4a9ba8f4dd4f71016c5d1cffaeb7df4fa182207efa1b4d69e9a9bc3f9d75 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:3b814f16e4f2cf1f34d1e8343abe7bda266f69442651ec0b051a0fcf6e5d76c7 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:0721147ac811fdbce36816da4cbf95d34c89b89393c354dfdc3a0e246a366f55 AS pg15

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.1.0@sha256:53acdb91a92d31d17020b6f60dc34ba47c454827cb59f814ede01fb539754247 AS pgrst11

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
