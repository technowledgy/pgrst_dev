ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg12@sha256:4418324817ef091aead08daf16c48f4e97772c278c631dba8038090595148c97 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:56628ba03bd57298a85a3d8843920d6d488b0a9902beda3257072f840fd9b988 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:2b8ef0e4bdbc0ae7abd218b07cabdaa7139d4b29849d9ed11e96b08c83812ae2 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:77e4024e34502bdcdefc0066b605e7c852a61c40292db43ba1f9e7bbc25d5561 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:d2cea115b26569f7cabd3e1f0a4854f4831dae23c0c6900db2c0da3eac56aa12 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:301bf8cb7f2238ad6d6720fce4c6ecdf500d7a7cfd3d62e77703eeca1742d12a AS pg16

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
