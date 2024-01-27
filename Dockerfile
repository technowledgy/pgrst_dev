ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg12@sha256:242f72ba941bbda1a33805bb7388f46d5855bfee46a10c99c76dede30bd314fa AS pg12
FROM technowledgy/pg_dev:pg13@sha256:fe314060aba32a3d03bd552bbd8ca555e82428cd09277013c2cc9e528519ec86 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:2ad16267641bd65b493b436554a7b1e727fd3bf5176b9425da14e0364a24c995 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:d050e3c76c957f443802e0361fd75f77ba7c0e3a66dafde2b0ddcd836a848a0f AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:21de29894404d5743dd87958e40c1338d606cda7b4921f17416a85e122d0509a AS pg15

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
