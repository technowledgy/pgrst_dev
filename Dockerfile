ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg10@sha256:9c21e2d00eedf1216eb9f4022d5f30892d5e854adf102dd869b6e97752001b57 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:6167051e5a95416e35fcc0baa74572ce3b73f057c47db10c9aeb3c77a066732f AS pg11
FROM technowledgy/pg_dev:pg12@sha256:fb432c92ac6dae6b4281aefe4278edb4a614734abe7ef179f78e514c2b806897 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:8e1a76bc1b0985d9af2c5d8bf25306e7333f4d6c46e2a93601df4e1ed7e8734c AS pg13
FROM technowledgy/pg_dev:pg14@sha256:32bec128168a5f8f47f027b84152bc7948fc6f48662434355a345c784724771c AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:a2532666e5e70782d1f121467ee8216c572faf081e6013987ada4b40ad3c69db AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:a90b57c94914927ab6650ff3444c60dca96c4daa7798fedbb2c0b3fce7dd75ab AS pg15

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
