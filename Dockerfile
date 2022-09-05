ARG PG_MAJOR=14-invoker
ARG PGRST_MAJOR=10

FROM technowledgy/pg_dev:pg10@sha256:b2a41bf6fca50a2a7a30184975d6a047ff9233a5ab9cefcc0dd39e478923e5a7 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:884aa262064b80a6abcb7083f1644e8b1f4ca8f7801e9fb61f39ea63feb42ad4 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:d6523fd9b8cfeafcc3e747221a4b9ff5ddee2a3ff4153d12efe5c8700f7d8f61 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:4e948802393b0c2405f3ef7b2eb3a8626f4d8c4bc92af1c9d4c9ffcc08a69925 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:702c87438373c49e00de3e078a6027d3c0aca61669b387e903b65f7dd158876e AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:af3bb56769fef7c97bfebffb1b3d4f098ccebc68d9a942b5b586f4e82a09d7c6 AS pg14-invoker

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.0.0@sha256:080b61c2e9d78ea473353419f07788114835e46ae5ae93c0e2b532a011d3ad49 AS pgrst10

# hadolint ignore=DL3006
FROM pgrst${PGRST_MAJOR} AS postgrest

# hadolint ignore=DL3006
FROM pg${PG_MAJOR} AS base

LABEL author Wolfgang Walther
LABEL maintainer opensource@technowledgy.de
LABEL license MIT

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
