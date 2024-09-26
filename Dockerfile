ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:d6b1db1f35db9671e654e845e1a1344243bae739bee8052e2a73557f008242ea AS pg12
FROM technowledgy/pg_dev:pg13@sha256:874ae10b720a82bc4033e696c7d646608d5ceaf1561d826221139958a6095ffa AS pg13
FROM technowledgy/pg_dev:pg14@sha256:0e720cc6c6b13ecad4e34f6b57201ef02755526712ceaaa94b526ed78ebf5b88 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:e3df8229af58619e162d0dd15a702741216da1ffe37ab9627db9ba088d8676c9 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:aeca058a8b2c74c3bb5aaf40d0898a5fc68213cf014f2221909cb5946602585e AS pg15
FROM technowledgy/pg_dev:pg16@sha256:805d3d7efcc95b272c9ad3e1e588e37cdde5da3e0b02a9311d4613fdb99b168b AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.3@sha256:729bf65c733b73f5b52777f0e4b853f22ed73aa67a22d38269d289779b0a8401 AS pgrst12
FROM postgrest/postgrest:devel@sha256:10b097ac4fc9b2b4d0884f14171576685530da66dfe3cfbeab7691a96249eb83 AS pgrstdevel

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
