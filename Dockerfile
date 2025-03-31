ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:1c6a10dc6adee89595918c11330ffe4ff371a52f463510ecd3d02708e31cd1d0 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:4923c3797ab6691abc8349a7f8152b9129d5d08fcde141a495e6873b6dafa9b7 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:a96c350f410c106fd40511dd4fa83e33cb2775cf79bdd50e12a606e206fc86c0 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:74ce2d0af9d2606db28184d9651391d602c8afff7f7048be7564d58bb93189f0 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:bfd722bf8ffcbffbb708d4d4076d8d00f66cdb1a2f0eec1f6c654a1164d529e9 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:7a75c4ad1349d5cf49e7f1ba75ffc8c962df37eedb08f7cdd82e9dbc394051b0 AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.8@sha256:e5978740a590628f2114730bb942f35342ea70b8b7a86697a3df283c0caea109 AS pgrst12
FROM postgrest/postgrest:devel@sha256:c222b143200f4437e91c823830fd11ed39aa634e59947e53489f475dde4a8927 AS pgrstdevel

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
