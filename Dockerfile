ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg12@sha256:fde0eb1c91b542515c182ed37adceb770dba54ddd45ff214c7f8848bfbf51208 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:33ff2cd0899f32cdd6aefc3253f1ffe2295f8ef55989c1bd8fd67f6fab479d6b AS pg13
FROM technowledgy/pg_dev:pg14@sha256:4a11d74a35e942d37ab0dc531a81286a555d0640a5ea3e254e7fad50988e4470 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:9f8df6de71cc72fd30648b69c8343d8014c18eaec55b4848c0c3beb14757a5ce AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:57f64f43d1b8ab0604accb8f23a1dd08b9c53593199ca70a1a2627bb9f556a46 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:ddbc1320e83d352d45c565756926df5b60e7d96e60dfde3452c0c47b6b3b1645 AS pg16

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
