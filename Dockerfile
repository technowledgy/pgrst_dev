ARG PG_MAJOR=14-invoker
ARG PGRST_MAJOR=10-pre

FROM technowledgy/pg_dev:pg10@sha256:09a332eb853a88335af70fe7b4053884da7f7a050a2555de081cfadc4fc82baf AS pg10
FROM technowledgy/pg_dev:pg11@sha256:91b16fe9efa5824152fc41071ee490b64d7e2cabafdc217bbbaa03de0722a92f AS pg11
FROM technowledgy/pg_dev:pg12@sha256:3b9e9c4ce8b69e081999040936cd3ae3bcb422128c3064ac6a42144af529722d AS pg12
FROM technowledgy/pg_dev:pg13@sha256:9798f8589326b0adb7c22fdae4ba98f4eeb3ddbb05a55d5942064a99c537da18 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:56238d15a436514b22798e8853afecb765ca36c65b215b41cabb37fe090d9926 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:16a0d4a01787745115ccc1d0698e064503ca65135697a1d0582c324501567db4 AS pg14-invoker

FROM postgrest/postgrest:v8.0.0@sha256:4a9e69d24d731b1fa7ffe2691c7943dc1f91121e8d0e2d3e61319ab108f27f29 AS pgrst8
FROM postgrest/postgrest:v9.0.0@sha256:b9f7ba9ecab10c6179e9dacbd65c90c2a794d91bcfbc9589b802db7545e04223 AS pgrst9
FROM postgrest/postgrest:v9.0.0.20220211@sha256:b82006c3ac5caa49b5d7330e64cbd2792d9d6ab3235c53b909cb9f1ce575af0e AS pgrst10-pre

# hadolint ignore=DL3006
FROM pgrst${PGRST_MAJOR} AS postgrest

# hadolint ignore=DL3006
FROM pg${PG_MAJOR} AS base

LABEL author Wolfgang Walther
LABEL maintainer opensource@technowledgy.de
LABEL license MIT

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
