ARG PG_MAJOR=15
ARG PGRST_MAJOR=10

FROM technowledgy/pg_dev:pg10@sha256:6533fdff693a0dcf489ad6a823debd186ea4fb68c824c682ff6b2f7b12b51291 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:d0bddd9f6401f7951dc72a5e585bf47a68243e34cfec1d85950dae5d00d392e3 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:71f7b93a45b83d0d40b2ce55fcb5e83e22341ce9ce13ded1c1f14a37286362aa AS pg12
FROM technowledgy/pg_dev:pg13@sha256:b9cd7ca69568d7e7ecf1170296a0d271d4372316d6e487a91d8550f918ec5626 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:dc5065c442b4db642f0f67fdf877f68d5417f34e0bacdb6f665858e586aed962 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:f4879669be3f6781618e3d7071165c92003ec9ce8d328a3d816080426a52da54 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:f5778d27906f7f77310c52bf409075f864f6f1fbccc37b7e966238c0779ab8ae AS pg15

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.1.1@sha256:93ef9468e5da753fdf181b0968a0527eaf8de91231804269e4636e8c2626a6e5 AS pgrst10
FROM postgrest/postgrest:v10.1.1.20221215@sha256:a578e057ec58cf599293d9755185ad7c441bd7d0abb9f1f21d0fd116aab7f392 AS pgrst11

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
