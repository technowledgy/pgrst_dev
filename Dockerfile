ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:c83e59c18548141d4fc13c3042f50c00d24618f9b016fa0ad050cf3fe6594b3a AS pg12
FROM technowledgy/pg_dev:pg13@sha256:e6ac6178a9bb37dd0899df4771e04aac117f349a41c74d02be5971def3917dd6 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:c7e23a7e46ce091e737b88ead46f2f92b4044d9308429812139128b30c93c119 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:1d1f729546b358c44b08a52c2cdad679d156af58f938bb099e31cae08758c53e AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:91a2ea8b3bff0be43c57d06084b6561745907141f89e25cadc5f92829d9639e5 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:3d8b06abff8644c24be2c004d798d02dd5b7ce12dd51c63d0ff8d3f596f8913e AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.12@sha256:5f4ce744539bbba786b4e24dbbd95bdb2a956dcf568c5374995a0ff4a68f5bd2 AS pgrst12
FROM postgrest/postgrest:devel@sha256:e5ed0434c3930b627ef9631bae53ca0daab63eb31f7f42e534754291b646176a AS pgrstdevel

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
