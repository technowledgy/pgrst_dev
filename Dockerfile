ARG PG_MAJOR=15
ARG PGRST_MAJOR=10

FROM technowledgy/pg_dev:pg10@sha256:5de76dfcd2fa975e913b314bc7a9228178b24588126545030c449ce3428b1955 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:5c2a200ef76e741ef4386b1caac1cd78bf6739c17697693344a8163a8cd70f20 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:0a461517260bbee40fc150a38023f7fcf2d5df8be7657dc4ecc0ff29b28d203a AS pg12
FROM technowledgy/pg_dev:pg13@sha256:a7cbed611ce23e9651399fad4d811c28a8f126057e1f2d64ee8c4d2867fea73b AS pg13
FROM technowledgy/pg_dev:pg14@sha256:d9d0c20193de8ab30eac5e849ad22772c7998295cf113f2a3e02e72a62bd4cf7 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:728bed3cfa6dab5de552803d10f3fc27d84d791233c195e3ac422ce44c1821d5 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:3c40e5251fbc624957386209742fd051dee0ef9cf9defca807915b5d262914d4 AS pg15

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.0.0@sha256:db9dd042f5a4f7528b09723e08434b1ffadabeec8079e33ff38ebd8273177100 AS pgrst10
FROM postgrest/postgrest:v10.0.0.20221011@sha256:3697575a56cc09460b4d212c78c799304f97640eb6bb3edbc16959b2546b16fa AS pgrst11

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
