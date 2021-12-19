#!/usr/bin/env bats
load "$(yarn global dir)/node_modules/bats-support/load.bash"
load "$(yarn global dir)/node_modules/bats-assert/load.bash"

PATH="./tools.$PATH"

@test "with pgrst runs command with postgrest available" {
  skip
  run -0 pg pgrst curl --fail-with-body http://localhost:3000
}

@test "with pgrst works with custom database" {
  skip
  POSTGRES_DB=test run -0 \
    pg \
    sql test/db.sql \
    pgrst \
    curl -s http://localhost:3000/rpc/get_database
  assert_output '"test"'
}

@test "with pgrst uses default users" {
  skip
  run -0 \
    pg \
    sql test/user.sql \
    pgrst \
    curl -s http://localhost:3000/rpc/get_users
  assert_output '"postgres,postgres"'
}

@test "with pgrst uses PGRST_DEV_AUTHENTICATOR and PGRST_DB_ANON_ROLE environment variables" {
  skip
  PGRST_DEV_AUTHENTICATOR=authenticator \
  PGRST_DB_ANON_ROLE=anonymous \
  run -0 \
    pg \
    sql test/user.sql \
    pgrst \
    curl -s http://localhost:3000/rpc/get_users
  assert_output '"authenticator,anonymous"'
}