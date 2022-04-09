ARG PG_MAJOR=14-invoker
ARG PGRST_MAJOR=10-pre

FROM technowledgy/pg_dev:pg10@sha256:5adf7634a1993e367e6b54b27887763368da3364222eb67f80b4cf467da47386 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:ef465969cbb21118d21052a5d03a5df0493daaf4745ec361ca81c6b3987526e7 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:535aa982a122115451b9cf615b8687c2735233809108b0db46fd5b5083aae92d AS pg12
FROM technowledgy/pg_dev:pg13@sha256:acf42742cc7872dca636f30f2eae7ef8b70f33b5b7aab5f5da7be03afc6def86 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:b1e3c42c6a3bb356a0ff3a85bd0a84bc90193bea6394119dc082ec2ee893e22e AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:e3e76b214fecaff15043db1e09e0270b96a03564ccd1396825d3a7689c6994da AS pg14-invoker

FROM postgrest/postgrest:v8.0.0@sha256:4a9e69d24d731b1fa7ffe2691c7943dc1f91121e8d0e2d3e61319ab108f27f29 AS pgrst8
FROM postgrest/postgrest:v9.0.0@sha256:b9f7ba9ecab10c6179e9dacbd65c90c2a794d91bcfbc9589b802db7545e04223 AS pgrst9
FROM postgrest/postgrest:v9.0.0.20220211@sha256:b82006c3ac5caa49b5d7330e64cbd2792d9d6ab3235c53b909cb9f1ce575af0e AS pgrst10-pre

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
