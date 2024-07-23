ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:208939b337668e59f9b4a4b470780d92e82bd3344320bdd0ff8f2db22eb11cd2 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:176d2f4fb62b747eb67c193168fb685588239d0e592789459c91723ff36b6794 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:285631a166da3d4f028ace1255a02b719cc7e5cde11ba3584777261241e3fa0f AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:893f9b30833effe30c7f30767f36e31a21bc2fab2466d2de0e3f7f0f8af298f1 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:bc2b4191c9b167774812494eff2aed0a94a7ea569b0870286dbf3e1cc24eb5df AS pg15
FROM technowledgy/pg_dev:pg16@sha256:6b80acc27be1f27b5380d693719497320ec3f1c612e895fcc72de8f9169c2fc4 AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.2@sha256:7755805562a33c0359c768a87d43f2ef6b2d13621778d43d15e12437c83f53a6 AS pgrst12
FROM postgrest/postgrest:devel@sha256:1dbcafd373569d0a37c186ed6149b896de01f5b1027242572580d2ea53e15c59 AS pgrstdevel

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
