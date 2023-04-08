ARG PG_MAJOR=15
ARG PGRST_MAJOR=10

FROM technowledgy/pg_dev:pg10@sha256:3b4c0a4f60c486ee87a4c0cf989ecb16ceeb45943e5b87c105d2cccd97d9d942 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:2d648f2a1a7e4461fca120b1d076122ca69c3311ab5a59f101208c962c99483f AS pg11
FROM technowledgy/pg_dev:pg12@sha256:4acea89d67fb0dcbe8dc60c258005c87a87b4e9428bfa71b0ec87089d8b105b7 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:b0a25a1bbcaeec2f4a5075e62ff9548619ae2094aa7a6c634790a3b0bc7b1282 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:1ac939af9e258ee40646c25a4f5a97a87872055e91dd494aca2a007b1cf39d2c AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:638b501ac53365388c8ce6e0721f23aa0e33c0a6edc8d5acfe1254d5830dfbfa AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:ce26c5ea91c86197dd852152d673acb1ac3acf00b3e97a25b40664f16914aff0 AS pg15

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.1.2@sha256:058d34b648f80f7782e1e062df13eb9b541825b38a6b521f3848af86c85be26b AS pgrst10
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
