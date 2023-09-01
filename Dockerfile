ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg10@sha256:f0ba36d06e7804ca53b40e84d4910b3d581be75eab03fa5647bf6c7db69b92e6 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:7134dd0c389af133efbfa3d414886b39a69414511cfb711878be4987a3aef5d6 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:6fb6b19dd4cdf322ad263d4e9287e2dcf8ef7bccae0c4b830f949bf2ee1c0b4b AS pg12
FROM technowledgy/pg_dev:pg13@sha256:be9130290921c1f936067e9928356e7ac824f6bdba6eb66fd8d43276b3bcb3d0 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:b0fcc2d59b144e06fcf494710c3df563961a862764e05d43dad3def13eebe554 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:e6bd4dcd3d8b8f050e0691847ee4880083d64805e3ebd56d471448e2105f8f97 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:4bf7535f3d39708297f9202f826ee9e6fba4a2aeb701c3ee08fa1734cc224f83 AS pg15

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.0@sha256:5cb1228f3d1fc6f3d0151a99180d11b38488c9dd7a2eafd95e9e309d3c2fd9e8 AS pgrst11

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
