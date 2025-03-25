#!/usr/bin/env bats
bats_require_minimum_version 1.5.0
load "$(yarn global dir)/node_modules/bats-support/load.bash"
load "$(yarn global dir)/node_modules/bats-assert/load.bash"

PATH="./tools.$PATH"

@test "with pgrst runs command with postgrest available" {
  PGRST_DB_ANON_ROLE=postgres \
  run -0 \
    with pg \
    with pgrst \
    with curl --fail-with-body http://localhost:3000
}

@test "with pgrst works with custom database" {
  POSTGRES_DB=test run -0 \
    with pg \
    with sql test/db.sql \
    with pgrst \
    with curl -s http://localhost:3000/rpc/get_database
  assert_output --partial '"=====get_database=====test"'
}

@test "with pgrst uses default users" {
  run -0 \
    with pg \
    with sql test/user.sql \
    with pgrst \
    with curl -s http://localhost:3000/rpc/get_users
  assert_output --partial '"=====get_users=====postgres,postgres"'
}

@test "with pgrst uses PGRST_DEV_AUTHENTICATOR and PGRST_DB_ANON_ROLE environment variables" {
  PGRST_DEV_AUTHENTICATOR=authenticator \
  PGRST_DB_ANON_ROLE=anonymous \
  run -0 \
    with pg \
    with sql test/user.sql \
    with pgrst \
    with curl -s http://localhost:3000/rpc/get_users
  assert_output --partial '"=====get_users=====authenticator,anonymous"'
}

@test "with pgrst works with PGRST_SERVER_UNIX_SOCKET" {
  export PGRST_SERVER_UNIX_SOCKET=$(mktemp)
  PGRST_DB_ANON_ROLE=postgres \
  run -0 \
    with pg \
    with pgrst \
    with curl --fail-with-body --unix-socket "$PGRST_SERVER_UNIX_SOCKET" http://localhost
}
