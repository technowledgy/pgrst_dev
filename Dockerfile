ARG PG_MAJOR=15
ARG PGRST_MAJOR=10

FROM technowledgy/pg_dev:pg10@sha256:5b868149cecfa1881806259b153f7783d304e96201425655dfcf6273b39e0901 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:190354417c516addd765b59bff049e51da757c5f166e01df35958d64ffaa666d AS pg11
FROM technowledgy/pg_dev:pg12@sha256:de3d3ad614c20bbb7c67e643eab42e92bab7b502030207905289116df9e9858b AS pg12
FROM technowledgy/pg_dev:pg13@sha256:1e94f85516373b730e8538964be29b69218206df15d2545e245c40fd6e7b13ef AS pg13
FROM technowledgy/pg_dev:pg14@sha256:e0e121173daa0193f0c9bfdb8da389074d4b1006627c7a05d2e3d2ec36789157 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:e04f5a97359c4d508ce4c2c88f3638d179fe1101164d6f7f2560372c20e2dc3d AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:f5911f5d05f1dd0b05166039750e37f298347243d698630e5c82f310828fa146 AS pg15

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v10.2.0.20230407@sha256:e843f6e2ed340a0944669cb6907ff321b4b804c4660c4cf0cab7fc947bae077b AS pgrst11

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
