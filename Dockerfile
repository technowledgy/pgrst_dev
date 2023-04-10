ARG PG_MAJOR=15
ARG PGRST_MAJOR=10

FROM technowledgy/pg_dev:pg10@sha256:e22f81828e444654b89ce0eb78184ec49443917a0e92f80073a57402d1db8376 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:237877c5e0a906e19fabb9930d9c8b026c6cbda5b7a41cf76ae62d23e32174d5 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:45e5fbf72ae8276961669d4142bb31ab121d1fea1bb85df7d19d227dc3cbfc09 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:91e7a289cc60d05985eec98af845de007272d4b08ce555e436a6998d7499a5ec AS pg13
FROM technowledgy/pg_dev:pg14@sha256:686e74172612578e96950db17045f42a6e2f14846ce7d61e2eddb97c14e2081c AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:938957554330cc6e95b3ee297fe6654360f6f88e64f2604ee23161084be6f283 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:6275c6ffdddfea2a89d86fc9f3aab5e44da5f13306208665c809dbd50f00dc7e AS pg15

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
