ARG PG_MAJOR=14-invoker
ARG PGRST_MAJOR=10-pre

FROM technowledgy/pg_dev:pg10@sha256:849ed27a1565cdf15ab3a3b6f492b86304d69cd82f96950c12b086edad102cbf AS pg10
FROM technowledgy/pg_dev:pg11@sha256:260fb2e37ef00219d02fbd4ddd9be00f8a751fc4291df8763125ce79d5e4a09f AS pg11
FROM technowledgy/pg_dev:pg12@sha256:fa5242a8eff5a0541b686c9d13c6ab8d697541fba0fad3c2528130be5cc8cc14 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:c2e1f3d8f1bac440443a3420f7007ff264189921c2bb52963218a4928247c21f AS pg13
FROM technowledgy/pg_dev:pg14@sha256:a8775c3bf33aa79e76a5287f65d26a985fbe4aa84f94c24bcd7ce91dac124514 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:f6928f62fbbbb5096089069211f5a5d95fdd8988253b5de314d6f66a43b0eca1 AS pg14-invoker

FROM postgrest/postgrest:v8.0.0@sha256:4a9e69d24d731b1fa7ffe2691c7943dc1f91121e8d0e2d3e61319ab108f27f29 AS pgrst8
FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v9.0.1.20220717@sha256:efee06d36db67cffe9091c5984b333f9e06a31a42196db7cebf8f72b72adaa17 AS pgrst10-pre

# hadolint ignore=DL3006
FROM pgrst${PGRST_MAJOR} AS postgrest

# hadolint ignore=DL3006
FROM pg${PG_MAJOR} AS base

LABEL author Wolfgang Walther
LABEL maintainer opensource@technowledgy.de
LABEL license MIT

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
