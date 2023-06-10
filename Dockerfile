ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg10@sha256:611e631af4d2345b709cdca36573e154292b3f239b4541cc72d1dbc37503fc46 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:9bf86cfade3df9901ea4c7eff1e8c40265b70eeaf43bf63338ba1ff041328dfc AS pg11
FROM technowledgy/pg_dev:pg12@sha256:893800df0342c2b761a13317347e5601fad242a79b7b8aefe7b38a3f2a9c613b AS pg12
FROM technowledgy/pg_dev:pg13@sha256:627121d325fc7b1003de119eebcb5db88cdbea4b87f0c79e69f8533ea738a00a AS pg13
FROM technowledgy/pg_dev:pg14@sha256:485f5d285b4751abc37ac9b18c876f045e96629709d389ffaa2d691ccd37ed70 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:9fb93bf081acc11c70fef5110b671d78e5c73e495e957e76584da78069861410 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:9b052de97ac7c6b87557688dc23c01a06bf2ff359d745932f279425bf96306c0 AS pg15

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
