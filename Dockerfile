ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg10@sha256:814180e33c5bb71a952fc4ad5f30da6a6cfa1542fff9bff3f477450221890a53 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:1831741a2a9bf2d5978488faba66845d28503ef6ff4aaa749de30dabf47860a2 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:85c76d10ff8bb36feddf182a65d5e06b857712d3221e8255d8529ae307b808d4 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:4429557a510f28ea27894b3a8b383d1875a73788d7c6f57263d9bd33638b3457 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:f89d0e3ac5662531af0fb86867aa6f6870dfdabf1e7aeb0bb401d5cdb2c4656a AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:b911d99f25f530ddac42da102fe74fe89ccea50c5419683aa1cac95f09b72a7e AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:edc55bb96e51aaa958789e9503c1f424918c6d28383d50b000841c071c5ca659 AS pg15

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.1.0@sha256:53acdb91a92d31d17020b6f60dc34ba47c454827cb59f814ede01fb539754247 AS pgrst11

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
