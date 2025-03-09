ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:5e1d3fb01b8dcdf05ce2fbe02c417cdcd49675d4dfe5650b0f3b4574080723e8 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:9bfe1a2e80d394bac14d4e642a9fdd46043a24e22b7ff44551a52f5a1feeb2c7 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:0ba61f2b328cad8fa79b0fa0c73dfed3810ab3e15f07d2899cd0fb232710a834 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:4283cf5f1e4cbe49a46543e5a9dd6de18c4ac53cad0ef495d364781123efb1d4 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:5864b7a8331cdb573fc1132d04534163cf4010c9bb93263a77dbe5896728440b AS pg15
FROM technowledgy/pg_dev:pg16@sha256:1b8b5bdae52d503c7316355ea07b7340f9eeb962bff53fe141034a60eb749f78 AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.8@sha256:e5978740a590628f2114730bb942f35342ea70b8b7a86697a3df283c0caea109 AS pgrst12
FROM postgrest/postgrest:devel@sha256:848346a029329ae955fb6c3d690307fd5421b1d83ecdd3b4cb32e4e5c44ffdc2 AS pgrstdevel

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
