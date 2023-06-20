ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg10@sha256:1989e9615ddfc214f8da08ab8e0b0f4fdeae66cd7633e45699c47573e4658447 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:baace3887c73457e6ce420df4582d3b9ea646b75573c2742e3cf1bf35707a46f AS pg11
FROM technowledgy/pg_dev:pg12@sha256:49ead11769752e2cfde070bde4d777fc1b9f9e97955b9aa7f543ffedfce0723d AS pg12
FROM technowledgy/pg_dev:pg13@sha256:fe662d631a972e8025e50dc6fdf06e7516f23a950042546bdffdf91d72ba91df AS pg13
FROM technowledgy/pg_dev:pg14@sha256:c6bf0b2c5f5a8e15e4d15da20b9193f38bac1c3d94143d820d13f7e8e8bb91f2 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:9ee6d4b0a2d9f4478dc809104618c7cd721fdfd366c0088cc67b8f60c8f05730 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:5b6d8e14ace950ba3ec00f793e715c1dcdb25be8242de3264ab24d99616f38a6 AS pg15

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.1.0@sha256:53acdb91a92d31d17020b6f60dc34ba47c454827cb59f814ede01fb539754247 AS pgrst11

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
