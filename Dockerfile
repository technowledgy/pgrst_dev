ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg10@sha256:1497cf52605b338ca6bc1f2af96e9cfc38b8209d0265f919cc51330087f5fce9 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:849631dad469da026520ba6d579cef12742cf87be0097f02f7369bb66246b121 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:0507660998e954c8bc547c0a362394624cfc3f6756da9c6a1d82b1dbc07e8560 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:436f6f22abe413bf084c163764679255c6638b664b8ca11c534d8f2c8efdd24a AS pg13
FROM technowledgy/pg_dev:pg14@sha256:b32ef0c1f2516afbffedf1998e73321d931263501d9197686394ecb55dfd8ac3 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:08122127cd857ceb686aa1e84011a5d3d194fc72ea951ac6fa967d70d37dcb0a AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:84f303ca37dbc4d2aa603e06e183164ac26810bb3e8a62f85d294b17f777eb50 AS pg15

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.0@sha256:5cb1228f3d1fc6f3d0151a99180d11b38488c9dd7a2eafd95e9e309d3c2fd9e8 AS pgrst11

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
