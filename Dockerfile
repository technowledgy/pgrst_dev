ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg12@sha256:c3daba4754fa9d0657bdeaa5fea99d85150e98563e7880918cba283b0819ebc2 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:6b9d3fbd2c2cbbfe9618b72b88ce5161d3f2e183cfc61851a66110f50a90ecfa AS pg13
FROM technowledgy/pg_dev:pg14@sha256:41459e6df50e96a0ff9c6df81d6eaca6bfb61544a645aa1a813233c88d0ae945 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:1ca10a825fee6273902dc3b6f65070d1d4246ed165166c977bda4a1ba8c94a01 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:e66d0a49ae71e97ae7d73c35aa95b0aeabf9cab7f13561643ea30867a624a247 AS pg15

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
