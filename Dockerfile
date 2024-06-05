ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg12@sha256:d2590ece9a98346a8f3025698031814886169bb735e3a88fc5afa8dad978bf1d AS pg12
FROM technowledgy/pg_dev:pg13@sha256:2b9ab395964932f11246adcca7b23a10410d86a01f7b56a91781eb1dee3ef59f AS pg13
FROM technowledgy/pg_dev:pg14@sha256:c8ee78c9df928db34c1bc115e2e6e14804a0f4ba86dcbefcc167c1bd2ac059a2 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:840d13771f1267f03b2d4a7a786c871a044d1f30dae864da71c984e1b188f34b AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:482a9f733ea879afc80c2687d5cc9ba790849e89db3f72b6a92d01039bb6861f AS pg15
FROM technowledgy/pg_dev:pg16@sha256:4beaab154fefb2d3a17ed828274e7af94e6a24af865e1a0fbdabf357cba6562c AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.0.3@sha256:25a7e698337da07976ea830fda7c513ed2e907094337a9833948fd30d9f77a06 AS pgrst12

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
