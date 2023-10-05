ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg10@sha256:daff1c3fb07246e5d91d8cc05ed046ed5830813e63e72aa35bc39430790f8c6f AS pg10
FROM technowledgy/pg_dev:pg11@sha256:4134f48564e692f3db57e2bcf558c4bc130b2493380e8c59e036e82e24d7bce8 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:36046fc460254cf2c06f0a6873b23edf969025a1e40b4e6dad0607d99a99e645 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:99f13597f4feec5aab795b302aba5bbda53f04f2c6ac3d12608cb2a95a8d0169 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:7b58693e7ca9636c16e13ce5ae1dc57fc0d3e20101463b796ca54f86aeaf433c AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:eedbcdcbfef4abe9d1e15e09bde8a1090d84aca9aa937b6c7d07f85b979d31d7 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:7e22e559a490104123e7966fb0008d5a1653e2b9c86a2b6c74db532d4c0a2bdc AS pg15

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.1@sha256:2fd3674f1409be9bd7f79c3980686f46c5a245cb867cd16b5c307aeaa927e00f AS pgrst11

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
