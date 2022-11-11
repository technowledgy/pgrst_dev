ARG PG_MAJOR=15
ARG PGRST_MAJOR=10

FROM technowledgy/pg_dev:pg10@sha256:e2d06efe8e971adf0ebee19fe578d04912729db612c5cb9727cf83eb84aa1351 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:07f0536f2abc22c868a69cffb2bfacdc4de8b48692738dad75328ad1aad98a0e AS pg11
FROM technowledgy/pg_dev:pg12@sha256:2d0959e732e5076bb141eb416251f45fc6f865f51864c69d7d3a3ffcb490acab AS pg12
FROM technowledgy/pg_dev:pg13@sha256:1732021513258e0901acf8018a6cc26158983fb6d9765aea8b42c2133e5ad5c4 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:b5a95c13d0b2e2b176718d37cc1b9ce22be5921572b894fa7d0b539613d32f2b AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:0f25093899a98cc3c8b5f4516e7cca92eda5e1e374468a64083b3f340ffe0817 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:2af07c7216cb22dbb22098b0d2da160536e1445fec8167403559e5a330e8e0a0 AS pg15

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
