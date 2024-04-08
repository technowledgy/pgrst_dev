ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg12@sha256:eab405716a557164974d25f4e0994000b68901df755c2dc8d83e34ed2f5c0ad9 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:efe4e4ad746938a04cb19fbbf5248e931318f78d82209aaac524a8641f3ab693 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:a59e485140d99aadecb2774fdfa4b94f3a5251b586b77d3302ee961621a2153c AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:a1cdc91906b11dc22033c09be98b27fff041a7344949c06e222e67bbe7a1a570 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:29545402dce63652adaaef6a87212cccaa5b5fd04ad5c8d48e40da5875a6ebf5 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:22d627141454d1a7c7ca7d0d434d02ee379bda37e753050c1a2906d17a5cc2b0 AS pg16

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
