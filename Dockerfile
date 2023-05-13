ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg10@sha256:52a62b6e10784d102c7f4cb9b8441cdf4cd9191da4c4ced9edaf35e8da3e1d5c AS pg10
FROM technowledgy/pg_dev:pg11@sha256:a57974e72502f0c5fc1bd808d080ec50cdebb08c20753a1e77ec384434516cd0 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:6ba8eb95ca4d2e724cb6b4e831d14fbfa57ec2a5a588e6edfae953a756fcca36 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:54c425afd24a535cdc575ad05bcd81dd34e033a30e78eeb4bac09d2dad8c6537 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:6e4fec813cee21cd3c7c2f65f9f23ec4a36c218d3c6262507d7335209594525e AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:3c566e96d67d5887ec6bc5536c7163e12dd2cfeabefad72cb8fc82b2510bf020 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:6ca6b818b4266ad0c4b81d0b14d81eec5318f87d8255bca484b51cb2b7b80a48 AS pg15

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
