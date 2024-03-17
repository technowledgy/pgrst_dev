ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg12@sha256:ddbed4be01ac7c1f0139a8f91ce0743b6425845e6cb908658a1f8ff7afc9f71a AS pg12
FROM technowledgy/pg_dev:pg13@sha256:47d922deeb4634320f06f3b13d10e74c97648d9bc8795d90d796f17f9f7db7e2 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:184b415025d6ac4ae628ba5b96dd92d8dba1ded96415a2066671e26c4c7e3dfd AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:cce5881591bffacb2319198eaf16a882984a01539925beb7e048f180d8ca2713 AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:3a225017c85b2771a487c0bc3ec46dac3ddab61961b1689466fcf9a48bd467f3 AS pg15
FROM technowledgy/pg_dev:pg16@sha256:35ca68f79526239dc188798912ab7cae4a9cf028e331bd7806ac2d33666a3c5f AS pg16

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
