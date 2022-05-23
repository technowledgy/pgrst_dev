ARG PG_MAJOR=14-invoker
ARG PGRST_MAJOR=10-pre

FROM technowledgy/pg_dev:pg10@sha256:d4030b82b79b8e091e934e9cd6c7d0e5c2285735bd55ede759dfb17005b9f219 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:88cb0adca7b57aea6223890b13519bb44d5baf7cd6bf0d99c91d5b1cfc9d175e AS pg11
FROM technowledgy/pg_dev:pg12@sha256:8d332c165243904f0159c3f262f6333c8151e4db4a83e517648c15c367dceb23 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:3353c47b942cfdc25f5f854c6772b05d9e193c355945b02a6195eddfd8abff22 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:226e9cac86c2bce05068fe5d8546526df0b6c55d2abd632e9632e9d57a90026b AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:63c5f503c7948c766a99794b0959b5871605707e50f82c6053f2de3405c4c3aa AS pg14-invoker

FROM postgrest/postgrest:v8.0.0@sha256:4a9e69d24d731b1fa7ffe2691c7943dc1f91121e8d0e2d3e61319ab108f27f29 AS pgrst8
FROM postgrest/postgrest:v9.0.0@sha256:b9f7ba9ecab10c6179e9dacbd65c90c2a794d91bcfbc9589b802db7545e04223 AS pgrst9
FROM postgrest/postgrest:v9.0.0.20220516@sha256:fe4afa1131bc69f8abde6e66800547a6daeb31f9d54f169967ae37fd25042b24 AS pgrst10-pre

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
