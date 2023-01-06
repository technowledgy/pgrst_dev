ARG PG_MAJOR=15
ARG PGRST_MAJOR=10

FROM technowledgy/pg_dev:pg10@sha256:b5a824223d2107e8e5bf168cf61e7108dfc5a21ce924ba423a67591d3eda64a3 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:48149f7e55851f03e5074032e4d71d5800ed5fbc89df83122a3fc986da53e759 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:d634eec0646b53de817a7b21e5f93a8462ad2940f959189c4ce28e7262daaecf AS pg12
FROM technowledgy/pg_dev:pg13@sha256:248512dcdcebcdbfe3457a5ee69a061ed119d0aac7232a5105811668c6c47f0e AS pg13
FROM technowledgy/pg_dev:pg14@sha256:3a0cb7feabb6267f6f7ccd134786166995348b3c5f94e46ed6608d379d42f63d AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:f4051e3ec9ea1294dad89fef77177638b834f58e286b96b77816f02a5e2c875e AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:23550aa28461747bc9dff680372405ae7fb2764640832c84027865d7852deb64 AS pg15

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
