ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg12@sha256:926f8ba8525b562d4cd619e8db6fd62d83bb152f39abe13a89c4af7da2bcb926 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:49f8a6a914d4b108bf477663c09b3e4793f83c71612bdac5cd068f98a94f4b2b AS pg13
FROM technowledgy/pg_dev:pg14@sha256:41f82aae1291d6d30c500e2e709d19fc012d5f310046adc69f710aa3cb1bc1e0 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:99a15c8f5262c68457a365b671db0a4d7cec257fa82796a482f55337a6caad51 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:6f653b72d68cb0008dffc915ceaf760382c9282a99803384330880bf89df1d65 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:b0df0f1c1d232454168f8dde49d892d6408d749012390fb187de63ca11e513cd AS pg16

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
