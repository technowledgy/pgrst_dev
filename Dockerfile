ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:7b3fa7db22d94095681d60326ef9837f436e15fc0797d0de9e11c477878d5548 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:ad99f8c1a9e1df302d2326559e9c3ad92e39714321add17f0b216e3f8172b5e5 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:9af43a042c0939a6d1e5225a5c2d260e5da5965388940835bb6376c4f3297f09 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:2f76988934bddfa85c036ab21d1c6e302b189c8b48ad67715a35270d33d26902 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:d3aa395ee508756bff1b06bddda7fc578d2b0b0c0e914218f247a86c89de5ba2 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:b2a2c40fff823e476376c0c6cc7fed8afea38017335b6991984df76776c349c3 AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.3@sha256:729bf65c733b73f5b52777f0e4b853f22ed73aa67a22d38269d289779b0a8401 AS pgrst12
FROM postgrest/postgrest:devel@sha256:10b097ac4fc9b2b4d0884f14171576685530da66dfe3cfbeab7691a96249eb83 AS pgrstdevel

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
