ARG PG_MAJOR=15
ARG PGRST_MAJOR=10

FROM technowledgy/pg_dev:pg10@sha256:e9e4b6728d32c88e1b6ee29323046ee548638809ceb3a7cae519443e88418a23 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:da2b436756060e3aff2dc79091473b16b37384a964f51f01c2972c37777bf633 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:8249a691b87765594c056c5c67d08c0e738aa91726765363fd3c559d57ff85d1 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:11594b69ca95c932939eb5c8e877af87f2ed18bacfccfc4b4fd3943a09c508ae AS pg13
FROM technowledgy/pg_dev:pg14@sha256:8f2414b64c2952d093e33de98e8896ef5e3e5b59f20368da041275d8139a040b AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:deaf842ff330dd2e5942d3cf5eb02c24c326260b224cc97d31e03dc29c6a58ac AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:b04368dce7e9000fe8fd0879f0500098f12760bdb622824d2c0a65eed206e223 AS pg15

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
