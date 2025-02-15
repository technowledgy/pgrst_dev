ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:62e7631a2f1bdeedcba2123b28e754e0563933c030c6814be4234fd7f4b70741 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:343d1ab6e677c06bc7a0538cc879ee28d846c4cf4eeca0fa089dd6e412b52d71 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:fb12384da253cd4e5df5d456fadee80a20f539e90f7b83e05b6b131e4cd98f96 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:e5fa74a5fca9a458165a99e41a90e1e4693de757c3d69ff0ca127a1f6bc7162f AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:86c52da49d243aadbeb6693331dbbd6470827cdcf96e3011112bbda90a13cae0 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:f17146c66125da05d0b3b2c4aefb037ebea0587b837363cbe016b4fe4259633b AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.8@sha256:e5978740a590628f2114730bb942f35342ea70b8b7a86697a3df283c0caea109 AS pgrst12
FROM postgrest/postgrest:devel@sha256:03eca1eb1a439a8a36bccbc41b5a9cb6b755e45dfe87750b801683a9d4bb8115 AS pgrstdevel

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
