# pgrst_dev

![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/technowledgy/pgrst_dev/push.yaml?branch=main)
![GitHub](https://img.shields.io/github/license/technowledgy/pgrst_dev)

This images uses [pg_dev](https://github.com/technowledgy/pg_dev) as a base and adds PostgREST for development. It's considered a drop-in replacement during development, while running the official images of PostgreSQL and PostgREST in production.

## Bundled Scripts

Currently, the following helper script is added on top of `pg_dev`:

- `run_pgrst`: Runs postgrest with connection parameters extracted from libpq-style `PG*` environment variables. The authenticator role defaults to `PGUSER`, but can be overriden with `PGRST_DEV_AUTHENTICATOR`.
- `with pgrst`: Wrapper around command which makes PostgREST available at `localhost:3000` via `run_pgrst`.

## How to use

Mount your source code into the container and run `curl` with a temporary database and PostgREST instance:

```bash
docker run --rm -v "$PWD:/usr/src" tool with pg with sql schema.sql with pgrst curl http://localhost:3000
```

This will load the schema defined in `schema.sql` through psql, start PostgREST and then fetch the OpenAPI output from the root endpoint.
