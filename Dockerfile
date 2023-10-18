ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg10@sha256:b04c0fedb266d3b43921caafba4869a55fd5d9d719407dda60b0d96a8d81f20b AS pg10
FROM technowledgy/pg_dev:pg11@sha256:359cf26758703e29524bcdc0107acf40e2495e958d6b94bdc783fb84e27af21d AS pg11
FROM technowledgy/pg_dev:pg12@sha256:88cf722b6e4864485ba7d9104b6321a267a9d1dea6d27d5cc842a9a37578010b AS pg12
FROM technowledgy/pg_dev:pg13@sha256:3f9e824d6478aa1f4ff5c72cfe4120e42b5ba2ea5f686fecb29c91b61e164cb2 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:9b9261e8c64670bc5cf457ca74c21a68374127ffe7fffd3a1eedde156b12c728 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:c2fb77d8895b9a721345d7c708b3c5f3258ffb48cec8943464f693d6eb682fdf AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:6f7068ebe614e582a66b7c3ee6163c444aa0e6fa22ccd0ae5aeb1e8d27d55599 AS pg15

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
