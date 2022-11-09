ARG PG_MAJOR=15
ARG PGRST_MAJOR=10

FROM technowledgy/pg_dev:pg10@sha256:a96b6ceac853a9e3879d861f4c07a17d8931ee30c8cf9d55bc4436d383e3f663 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:94027c2ae9b79b456804b95fa85ce7823d7aa936a36bf8a0e1e436419e962577 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:8a174b54a68bdc4f7794f33f0c75b3983e3792c8781cc922285c3d2767a1ca93 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:ead5b5ad5a7fd0f6ab93e175f7ce4730d3fb805620251cbab46790ea2766b636 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:664eba9a95794bbb4d2d10ec3af4014950ce963ea32e4cf03701f0ada0afc4fa AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:bf55d5b7c22b0d5ee9c5615296cf94258bca7684bcc378f4f5720e17221dc5e5 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:80c4766819010295b0a1fa43a59f9087caf94f2ee7cc337656a53f7c2f72e929 AS pg15

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.1.1@sha256:93ef9468e5da753fdf181b0968a0527eaf8de91231804269e4636e8c2626a6e5 AS pgrst10
FROM postgrest/postgrest:v10.1.0.20221104@sha256:6efcded152e7751d3df22c22c1323cfdce48266da48e90ab1b0cfc1787d37884 AS pgrst11

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
