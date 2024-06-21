ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg12@sha256:643387785c4a7cdb23aaba4f7d63ad83869b9ce2a4015f954419e140134bded1 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:e973b766c3bd73c96706e338b49f663e8594d670817a3e25a96d264729ad0b3c AS pg13
FROM technowledgy/pg_dev:pg14@sha256:666f9c1df020d30e20967554f4eba104906e2896d7d1f63df3fc88f2ade8eed5 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:a72ae7994b3a9cbcb7baf8f4663e1d9113aebc860928ed5686f9e547231aff38 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:d415042e9079d94843778e9f736ce903abc3ee8b517d2a413f896b2ba90341f1 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:2304cb55ea68c02fc90e3bd2343e483f57de0d990e22ac1b22b374dc2e5f9a5a AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.0@sha256:2cf1efd2c9c2e7606610c113cc73e936d8ce9ba089271cb9cbf11aa564bc30c7 AS pgrst12

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
