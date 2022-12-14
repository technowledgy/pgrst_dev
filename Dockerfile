ARG PG_MAJOR=15
ARG PGRST_MAJOR=10

FROM technowledgy/pg_dev:pg10@sha256:82d3138b6f32f3595cae22fae1e1c55d538bfcff8b6825ff2ee6eb187d5a9aef AS pg10
FROM technowledgy/pg_dev:pg11@sha256:61f9b0085f3da767b7ef82d43a5926adfa0a1fd783791e5d0e8fe9c715511837 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:2e810a99e5987a10bcdf99ca2d4713eb89d475fd071e1d9c7f9a2fc475fe5d5f AS pg12
FROM technowledgy/pg_dev:pg13@sha256:0b6c62be556f92dbafd1153061d42ed02e2ea8c464f6697941ca8c45bc57830e AS pg13
FROM technowledgy/pg_dev:pg14@sha256:2b2f1ed1b11e0a0133957578aeba4e963c80c29aaca1b0f0e7c14120b12b7441 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:5f3fbda8f5bb737b8cc8dc7c34c9a8d741d22ebbabdc18edd83f8942bbd9c810 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:9dfbdca64618e5f69c73471f9261debdd5388d1e3b0d5df927938c31c8ef5bbd AS pg15

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
