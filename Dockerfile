ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg10@sha256:b2ed578ced1aa5b6e2ec1308a087dc6128c2d4c16a8d7c4f8b7af49962114641 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:0f054ca9783ee98e9d396250764a580dfc88004afa545bb43f0916eae2f235ef AS pg11
FROM technowledgy/pg_dev:pg12@sha256:3730ae97cc2b463d6aa7cb48a5326c9e67d1ad616d0d2ba6dc50e6c0e8170a9c AS pg12
FROM technowledgy/pg_dev:pg13@sha256:5e7dc440050fee5733e2543e3ccfd7778821947b398dbc433219ab648bb96932 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:d5f4eaf7872a64b85d871bd9b195017f77f483a4361fa7e6e0afb2e09f9b6312 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:72caf152347c1b01bd4689ae37968070338c9745c5744190d6606ff90b66f21a AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:19b008e1d740559555c5445c0fefcfd604156858b979aee47f46f80793d9975e AS pg15

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
