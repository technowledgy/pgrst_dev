ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg10@sha256:4b00f5acde9627a8be6475eb7c78017d67be4ccd3e567a184f33072bb9da34ad AS pg10
FROM technowledgy/pg_dev:pg11@sha256:d298c019c9e50d193aafc872ee8c352b0a17799f8d03b5b733b4224133debe33 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:e94e1fa684bf0753c3c24b9d911d757f4fee18091bca9d03e0c1dd57c048f680 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:7f72af160db8710ee6eb401b5680a2203a9d58382de135b8b8b1603206d0a661 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:32afd2d5761f1fb7222443388981413601f49b7f6cb0e2c75a77f548e4196240 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:e2eb80ccc00eac81b25c3e1eb772ca34745b0822b52c15b41e54477b74dc149e AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:5ddc3469e28d422b1990b4f4b58881dee142854462503de2233e757b8b3090f2 AS pg15

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.0.1@sha256:09252a78f91726a764cbd71f1a5e40f7e76fb5ddada0c39c0a455fb9f8094648 AS pgrst11

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
