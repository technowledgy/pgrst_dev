ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:338a9ff37ecdd190581109e5184285c9b6760b53896acfce3eb3d67fe61db1b3 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:4de74c0e8e679fee61247d4238963a808aec4fd2e94b6f5aaf139f219d012395 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:fff6d29a265ba051d464c453f8ec29e19d8ac0225a41b118d7905e142bed3d84 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:c2b73d204c519f775a65919d98cb3d6b56a0f5f96d84da6168abdb67cfc78100 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:c248a5b7e1e6a22806c5132cabdbae6d63018d0794fc14a266815f562b7ab661 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:ed0aa25d04f361d029c9bae2cf497b0e689412126d52b9dc26de4493bb8eca9e AS pg16

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
