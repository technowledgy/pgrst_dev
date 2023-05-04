ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg10@sha256:ad1a6301090c80dd9f4fdcab5595c818134167b7859f7a3ae871d0bd61de37b2 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:6d09ade0af0adf97a41affc8469f0f05ad62bf38c10feb08c041fb5291223d92 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:ed5d6a8798d98013ed4a549f216a48ec193ae4dc78f78df9b25456fab1effed7 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:7a6429690ae1981be211bf895081c81173f63c11adea19e22976c5ccbe61b288 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:ad928b3af9d998342e6b4483d48e8657d9f12ca8968d86a7817dbaff51615093 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:06cac6983d8c2d48090c65ab33deb04db4e90968bf01c751c0948fc890957852 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:d929461d1a0ed5348b9a634350c9925199ee3d6889ae8e0572d6eaa85972fd50 AS pg15

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
