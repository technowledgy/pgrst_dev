ARG PG_MAJOR=15
ARG PGRST_MAJOR=11

FROM technowledgy/pg_dev:pg10@sha256:e2b31a100d40e995b64f91f25273c352af9bf28c62cc5d224d6aa2930c9ed618 AS pg10
FROM technowledgy/pg_dev:pg11@sha256:e5df12bb4f19d3d8f94211811066231f3a6156d89ba1c3fcd02de7ffc951b922 AS pg11
FROM technowledgy/pg_dev:pg12@sha256:52f6f0fd8d47a32543224627a06cda17c3de49fef32620cc7837955f2896fbe5 AS pg12
FROM technowledgy/pg_dev:pg13@sha256:b37d0e6208f163aa61b76067a678629a48067fbdd57ba5ac244de1e26f942322 AS pg13
FROM technowledgy/pg_dev:pg14@sha256:a1ed92482db9f9812baa547c9253c9bb678f77e5c1b2bff5ff7375385ac83174 AS pg14
FROM technowledgy/pg_dev:pg14-invoker@sha256:ef3d916eda16ed7b5d8a62aaba87fe624b0674f523c71710d9a95c987be4145b AS pg14-invoker
FROM technowledgy/pg_dev:pg15@sha256:f1f25741c36551b9af0515f079a5b8385ad3768e0d00a5b33107d5f70003b83c AS pg15

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
