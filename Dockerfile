ARG PG_MAJOR=16
ARG PGRST_MAJOR=12

FROM technowledgy/pg_dev:pg12@sha256:3ce6b681d6076e800da9c389d8bdbd03701aedc0eb7422bb3d3eb002aa299872 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:04a3af267b6f3d8b97f0846adfb5bf9ecff6cac17407d840284c1adb779937dd AS pg13
FROM technowledgy/pg_dev:pg14@sha256:dc63714a5e93a57077af67cc5c335cfcfb64f886253adc143cec2fe12936264e AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:e41831155f632f29adb0bb2e6ba4bd3329e5bfa2ecf18782b6e7791a9c5eea43 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:79a8ebc3a2719e4015f62c506deab06d7c85f5442b47463b5eab0aec44ebf7d4 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:3460cad51635d3cc15c3dcdc5f955b58a53fba735478c09055675d476be06ac1 AS pg16

FROM postgrest/postgrest:v9.0.1@sha256:2fe9360dba5520267f4ba4be6bb9e399a63acfcd081090ca8598064ccb6ac4a8 AS pgrst9
FROM postgrest/postgrest:v10.2.0@sha256:0885714e16ad539d970c9a0e668a3184e814c488e1f3759a8f2ee40158e780cb AS pgrst10
FROM postgrest/postgrest:v11.2.2@sha256:23b2dabfc7f3f1a6c11b71f2ce277191659da38ab76042a30c3c8d6c4e07b446 AS pgrst11
FROM postgrest/postgrest:v12.2.4@sha256:46519e461c7bbfdc49d6b5040f8ee2d379aceebe3a2f53743bc201fbe4fe5f46 AS pgrst12
FROM postgrest/postgrest:devel@sha256:1d3731237d353259ca015334f00be69a6839a9f4621a1be1e0e92b5594b01fb2 AS pgrstdevel

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
