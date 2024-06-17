ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg12@sha256:fec871eb370f5a43be37a7b64f74dfdc85bbc6754de394651f50abe6bf6d116c AS pg12
FROM technowledgy/pg_dev:pg13@sha256:d5ba1cacec6a7439fb066d4e63a4b4c159a105358606f7de5249e6b9eacf6c02 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:a71743a85f64accb6b54c112ed21d9ff7d03170f5c2e30f3e0a59af171fcd348 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:75b830f6210417832dc79401f3ba65a20605fa2fa87646ac601cb28d454ce0cb AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:44d158bfb3645e6be453c0d25f7f7a905f468e023c9e31df8740f6dbded663bb AS pg15
FROM technowledgy/pg_dev:pg16@sha256:28781683746e423372cdb82af319294ffb186d33c1f51ecee7e735caedf5a23e AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.0@sha256:2cf1efd2c9c2e7606610c113cc73e936d8ce9ba089271cb9cbf11aa564bc30c7 AS pgrst12

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
