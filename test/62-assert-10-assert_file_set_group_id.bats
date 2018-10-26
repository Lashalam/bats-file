#!/usr/bin/env bats

load 'test_helper'
fixtures 'exist'


# Correctness
@test 'assert_file_set_group_id() <file>: returns 0 if <file> set-group-ID is set' {
  local -r file="${TEST_FIXTURE_ROOT}/dir/groupidset"
  run assert_file_set_group_id "$file"
  [ "$status" -eq 0 ]
  [ "${#lines[@]}" -eq 0 ]
}

@test 'assert_file_set_group_id() <file>: returns 1 and displays path if <file> set-group-ID is not set' {
  local -r file="${TEST_FIXTURE_ROOT}/dir/groupidnotset"
  run assert_file_set_group_id "$file"
  [ "$status" -eq 1 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[0]}" == '-- set-group-ID is not set --' ]
  [ "${lines[1]}" == "path : $file" ]
  [ "${lines[2]}" == '--' ]
}



# Transforming path
@test 'assert_file_set_group_id() <file>: replace prefix of displayed path' {
  local -r BATSLIB_FILE_PATH_REM="#${TEST_FIXTURE_ROOT}"
  local -r BATSLIB_FILE_PATH_ADD='..'
  run assert_file_set_group_id "${TEST_FIXTURE_ROOT}/dir/groupidnotset"
  [ "$status" -eq 1 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[0]}" == '-- set-group-ID is not set --' ]
  [ "${lines[1]}" == "path : ../dir/groupidnotset" ]
  [ "${lines[2]}" == '--' ]
}

@test 'assert_file_set_group_id() <file>: replace suffix of displayed path' {
  local -r BATSLIB_FILE_PATH_REM='%dir/groupidnotset'
  local -r BATSLIB_FILE_PATH_ADD='..'
  run assert_file_set_group_id "${TEST_FIXTURE_ROOT}/dir/groupidnotset"
  [ "$status" -eq 1 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[0]}" == '-- set-group-ID is not set --' ]
  [ "${lines[1]}" == "path : ${TEST_FIXTURE_ROOT}/.." ]
  [ "${lines[2]}" == '--' ]
}

@test 'assert_file_set_group_id() <file>: replace infix of displayed path' {
  local -r BATSLIB_FILE_PATH_REM='dir/groupidnotset'
  local -r BATSLIB_FILE_PATH_ADD='..'
  run assert_file_set_group_id "${TEST_FIXTURE_ROOT}/dir/groupidnotset"
  [ "$status" -eq 1 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[0]}" == '-- set-group-ID is not set --' ]
  [ "${lines[1]}" == "path : ${TEST_FIXTURE_ROOT}/.." ]
  [ "${lines[2]}" == '--' ]
}
