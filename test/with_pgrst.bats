#!/usr/bin/env bats
load "$(yarn global dir)/node_modules/bats-support/load.bash"
load "$(yarn global dir)/node_modules/bats-assert/load.bash"

@test "with_pgrst runs command with postgrest available" {
  run -0 with_pg tools/with_pgrst curl --fail-with-body http://localhost:3000
}

@test "with_pgrst works with custom database" {
  POSTGRES_DB=test run -0 \
    with_pg \
    with_sql test/db.sql \
    tools/with_pgrst \
    curl -s http://localhost:3000/rpc/get_database
  assert_output '"test"'
}

@test "with_pgrst uses default users" {
  run -0 \
    with_pg \
    with_sql test/user.sql \
    tools/with_pgrst \
    curl -s http://localhost:3000/rpc/get_users
  assert_output '"postgres,postgres"'
}

@test "with_pgrst uses PGRST_DEV_AUTHENTICATOR and PGRST_DB_ANON_ROLE environment variables" {
  PGRST_DEV_AUTHENTICATOR=authenticator \
  PGRST_DB_ANON_ROLE=anonymous \
  run -0 \
    with_pg \
    with_sql test/user.sql \
    tools/with_pgrst \
    curl -s http://localhost:3000/rpc/get_users
  assert_output '"authenticator,anonymous"'
}