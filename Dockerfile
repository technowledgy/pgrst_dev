ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg12@sha256:49b0ad1b87aac43cf41f061237498f15457119b77f7a33f0aaea8d9d8d4a3e82 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:83fdfc75783454cf9980364274f93c8a59218786e7b039741739e0a297b13bf9 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:0aa69d27c1b781ec19aec4e8c4e6b9717dce8202eb3ba8c8602160f081c48bba AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:8bad3119102a593774edda5aad0e44e157ce39543874dc8d5690f9ecd253a48d AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:68517a2d08b2adb1b9205404c6fdd7aa1e1b1dcde89a6c1513a35502336f4d7d AS pg15
FROM technowledgy/pg_dev:pg16@sha256:5d676eb03acc79bf99111f24d98ba8db612beffbc9a8a2e289050c13f01e7ee3 AS pg16

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
