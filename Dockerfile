ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg12@sha256:f93b016158f953ad7125bfb0547cf6b6f35481675883c90dc712dbad56064d23 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:4a7e0794aa9042132006550a8bdc833459efd8aeb9a39604baa4d2685c654f6a AS pg13
FROM technowledgy/pg_dev:pg14@sha256:c7d197f443a1fbd73e426471ecc630913e6ba98729529e344eae60983872e03e AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:31379c341214980081452e32b3d69039327344ebfe3e1fdb017d22bfbe957137 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:65806818eab2453b58f6a705dc2eac5f980b889a61b65e2f6d30308728038903 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:38991d408e7a4169fddb3028ccfb2613e7fe06039565803719247e8654d28f98 AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.0.2@sha256:79369c0cdf9d7112ed4e327bc1b80156be11575dd66fbda245077a2d13b803bc AS pgrst12

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
