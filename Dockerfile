ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg12@sha256:69456cd9f8fe140dbabbd9dc048348cd74c60fc2536bb6788a2c0cd63f05bb79 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:700c59aafd23d147c32dc1640588fd7f05d2d43de9c391940d9fe8a3e8804888 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:416f4be368ee2afe8a159c0c975f086866303bd16de22b920127f070c06460e2 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:cd3aafe785bc935a97878486f250c96fcb8382a30eee7fd777f3e82486293f23 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:c32d7b3d31244629f08ae9a412c7cbefc0f036b362abee2addcf795e7719faa8 AS pg15

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.0.2@sha256:79369c0cdf9d7112ed4e327bc1b80156be11575dd66fbda245077a2d13b803bc AS pgrst12

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
