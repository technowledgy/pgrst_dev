#!/usr/bin/env bats

@test "with_pgrst runs command with postgrest available" {
  run -0 with_tmp_db with_pgrst curl --fail-with-body http://localhost:3000
}
