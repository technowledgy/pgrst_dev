ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg10@sha256:e58643d5487e63b56262b6c3de2da4f048c7c268ea30046f495abc26ac2550ef AS pg10
FROM technowledgy/pg_dev:pg11@sha256:f0de237d729194457bfda47bca1ef3b593563a4b1f5d607f24942dc67f1e00b9 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:f6fb929b02975646e1ca96231a76f800f286aad1a5217f8106d6c34e3919274f AS pg12
FROM technowledgy/pg_dev:pg13@sha256:e737006b1c8f00f94f288e54abaaa264c338ec2cab050a598efa9aa52b1b3033 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:e27d1d382b74c1c18d06bf6651d136f0b9c4871bcb556c807f8ebb3ebb63ce8f AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:837dfe0dd85e9078d335007bd7a3625486b0b4cc5f1a67a4e42dc5e47fd31703 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:b456f42c2f21a92118c32d01083e2b285619a7d8aff6e24f30f450af971232df AS pg15

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
