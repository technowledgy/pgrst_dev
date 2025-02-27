ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:be4aeb6b247cacae5331195a10300a9252c012e381320c8083ea41251772fe60 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:28cf5ecd40f1572a1b7229b198f8b1844497b9d96fde6c13cf1740044305d1c2 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:b301bf119766df3fac0f82ff201a306898ff0eac4ca058252f3b4cb4a8ae28af AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:853f8d3d12abe211db88c54def5ee0c4ddeb905f706ac2f111cdd567c8a07577 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:72ffefb9c12a4bebd6400ff5f82225b818f0a9606a9316df3d2322a6c7b24f06 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:82dd33d599d4bc718b3382f115249e84d1e854aaa6af7375b379536014011481 AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.8@sha256:e5978740a590628f2114730bb942f35342ea70b8b7a86697a3df283c0caea109 AS pgrst12
FROM postgrest/postgrest:devel@sha256:8002c5a1214d4ff8f090bd546ba362e6bcec517b355eaa675c6261a4cbcde9f4 AS pgrstdevel

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
