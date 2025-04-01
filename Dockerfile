ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:2329ebae014ac7e16d530ece6ffd3a08dc8f0b4d8ea3d7a844018f4174541762 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:4bb2f68b86390b04a5176ff88823d909c45a6e525b26e8e174d17f659ffd58c0 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:91265ee58529335ef2847736b015268099d3533bd3e759074a8c171b5860318f AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:73ab516dd42ca81c6f330f3f597587e400198f056e2c7507a8821df2831d5fc5 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:d9c1f735c65e6b5e7412cc2956f4f9d30b10e029190c6fdf46fe677cb53c68b3 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:aff816a7cc62129878d16a52735fdd1e68f3cb0af46f39db3545169608f0820d AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.8@sha256:e5978740a590628f2114730bb942f35342ea70b8b7a86697a3df283c0caea109 AS pgrst12
FROM postgrest/postgrest:devel@sha256:f56015a1c8a9bb00c6789b7ba3736cdfc6aeaf617c5383df8bb70bca2bb6c961 AS pgrstdevel

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
