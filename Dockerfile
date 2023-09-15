ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg10@sha256:a2d40101a095730255b4459c60c4b7ff0778c09ab456b49903ad7175b996c63d AS pg10
FROM technowledgy/pg_dev:pg11@sha256:5e25388694945cbbf0f97acee095cb63c22ed336539bee7ea0423ee1b0b56922 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:74fe6cd0bafb37cad5ab88af5d02d6e91426b5d55958a60e92cdda94d93d2a26 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:26a15b7c4f38913689e9e92c00e04f5fe5ddf643ef717a16a141ed951a2cb39c AS pg13
FROM technowledgy/pg_dev:pg14@sha256:b79afe12d159562d6bc01fbe26a0c8f822042966d441aeaf515e06aae39cda27 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:04eb5b9920f12cbba3ee36281f3d9e70bc4b4ae27b93f630f424ebd2efcb7844 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:1dd4e5150ee468c942ddeaa93cb3377054d2b3c74f444b62f4a6831b578775c1 AS pg15

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.0@sha256:9a38d9565ab92675e0ad5db8e2a24f8aa2d2f98accb07a517a61e598edcbc98e AS pgrst11

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
