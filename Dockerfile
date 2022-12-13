ARG PG_MAJOR=15
ARG PGRST_MAJOR=10

FROM technowledgy/pg_dev:pg10@sha256:edea4075c832d3197f0ccd1fd5bea05cafacda889a353083e14ed3ea4a4c41be AS pg10
FROM technowledgy/pg_dev:pg11@sha256:119b87072587eb71e5baaaf31a748f24ff6b87a2636566feb8a8b9610b319c22 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:22d4944efc8c514313ab110fc624d6f2a0dcf32438f67a05310b00ee2044195a AS pg12
FROM technowledgy/pg_dev:pg13@sha256:682745e0e4b701f0c6c64f3b5e683fdc91fdb62fb95c61c8e182e476c67746ef AS pg13
FROM technowledgy/pg_dev:pg14@sha256:7fdae8881666ad264ce986f781ff975c94c3fdf2311ca9ba4f6f04a544feec34 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:4af7bf5e8bba77a94e8fd736a5c129c20933c44453d681b81cdcc69139a705e1 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:b5c27c77ac8747470b603b17f73566da7e0b51c2ca08526f247cc00b08de27d5 AS pg15

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.1.1@sha256:93ef9468e5da753fdf181b0968a0527eaf8de91231804269e4636e8c2626a6e5 AS pgrst10
FROM postgrest/postgrest:v10.1.1.20221212@sha256:e6809059cba6cebf9efd3153d68496f7429ae0b8289eeca4fadff81b4088997b AS pgrst11

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
