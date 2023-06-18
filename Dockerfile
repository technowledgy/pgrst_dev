ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg10@sha256:97cc88573e8d4550cbbb74d510891a0beab070ad2a6073fa503fe5c6de19a5fa AS pg10
FROM technowledgy/pg_dev:pg11@sha256:b2dc1c7031055a0d344055a5816343443511bbe00f1c94d26bca059f23feba65 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:715db661a5081c9c1684d671970395a3d22b46754715d10e21f1e63187fcc6f3 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:7237ab52e9f7967f16986ef8edec55483659a8d0640f71591f397f77544e807b AS pg13
FROM technowledgy/pg_dev:pg14@sha256:02a6a738f43532d8d7e909f0085880d62f1839063809a1798f1583d2932706fa AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:e841dcfcf3c5def108dea87967bef2c06550e83547e6decb06c0cb8a859068f6 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:3cf84a426108de8a103acabfda2a75a49e6c4537405062a86641d554f2c5a002 AS pg15

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
