ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:6ac853803bc5b4cbda979a791373459538092ce6d16be0a62e120997c02ffb3a AS pg12
FROM technowledgy/pg_dev:pg13@sha256:3f009c21db929491c88e00b6fdfcec9486990ae6806e7493aef47978e4f55df1 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:3461a2b68d286b65206d9ff365af0ebaa37846b437f44128d5e0506398ebf8de AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:c3de1de55013b367c0799590a44e79ae73de650c67a9e15dceee101fe637bb79 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:fcf69ada1c83f9b258a7024907abd8b66fc7cacee70411a5d2af682125741640 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:6b5f1440297556b2b791614f8c15404d9ae831cbedb469b51b7d8ede052e036b AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.12@sha256:5f4ce744539bbba786b4e24dbbd95bdb2a956dcf568c5374995a0ff4a68f5bd2 AS pgrst12
FROM postgrest/postgrest:devel@sha256:b335f3ae1790080629362f70d4b533bf7d0f19280684f33f7361b8d00e2c2980 AS pgrstdevel

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
