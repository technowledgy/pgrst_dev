ARG PG_MAJOR=15
ARG PGRST_MAJOR=10

FROM technowledgy/pg_dev:pg10@sha256:ef5047e53fe034a1046515707672cf9d3c4eb73d21e936234541b3de2555fea9 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:db5075bc5a13f77a2f88e59c61840d1a5df2837614e5e8f9c76df8a6558c12ca AS pg11
FROM technowledgy/pg_dev:pg12@sha256:6a0d47c25bff0979e5e3651f0734c75eed8a7a502388420bd21f7931a675dfc4 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:fecf2ae0d39530e5bd59c6f6055bcb3dd8dc865d65f506686e5301a77bda7597 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:89cb3593ef7fd0af1341e946e3160400d921a3d3557b290d967aabc8ccd9b23d AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:912d5c1c4e38b572c940cfa31f8a7d3c2e1775dc0503e7e3d99d8150640c9c9e AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:db25f29e85c9be8f6883692888f1a80e41a5527d23cf3bfa12a5367170d9e517 AS pg15

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
