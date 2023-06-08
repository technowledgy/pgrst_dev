ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg10@sha256:41f2faa7df488f230bad62d86b3bd541fd88355c037241301f826242453d5267 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:911c1cc82c644a8b531b215e3c2904f10b5c40dc3c75d0458b883f1c98fa22d2 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:3f716f9f0867d58c346696010a518d74d04f193dd60b74ea7d6112f5811d8990 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:58aeafd13edbd22fb2385a1dde5e4ee9efb88ef79c21428da7fdc6b45287bb13 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:c8928bc8cc8cdad8b51f6421cf0e5d5f32ff3278abc0318de7e32aa0e7b23c2a AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:507bd0ae2851584252ac762f89628fe1121abc0b423644e248a688579aed18f0 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:9956b47de180b4392a309d5f3eb77a19c4447365284bda235d3a10318bffa488 AS pg15

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
