ARG PG_MAJOR=15
ARG PGRST_MAJOR=10

FROM technowledgy/pg_dev:pg10@sha256:c360462a0116130289f2e7c1dc6c4b61f3f30aac54542958962695b522365a2a AS pg10
FROM technowledgy/pg_dev:pg11@sha256:595fdd5aee889b583f18ccc6d73cec8961151ea446e09e5fbc26357754de0d67 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:bad3b417b0b7258fec86795c937b2f523d9f7cac7c09c4da05f0439207c00f1e AS pg12
FROM technowledgy/pg_dev:pg13@sha256:542d4c9efea3df925e632d37364c401f67852722bab7eb0d957d398e0b334a3a AS pg13
FROM technowledgy/pg_dev:pg14@sha256:0cf8eb7e269441a91bcd2d95ddb810ff03cddcc70be52f203bd99ef90f55dcff AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:0765d83f03de7cdc97823f8327ce7df703e0da11d7e83af9f61db3217a8ec7cc AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:703006fa2fd073742d6a03fde7e4f6d378273b66cd969578438056e26ecb8a3c AS pg15

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v10.2.0.20230407@sha256:e843f6e2ed340a0944669cb6907ff321b4b804c4660c4cf0cab7fc947bae077b AS pgrst11

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
