#!/usr/bin/env bats

load test_helper

CC=${BATS_TEST_DIRNAME}/../.local/bin/tic6x-none-elf-gcc
CFLAGS="-fleading-underscore -g0 -S -o /dev/stdout -xc -"
XCC="${CC} ${CFLAGS}"


@test ".size not generated for function" {
  run ${XCC} <<SRC
void function(void){}
SRC

  assert_output_excludes_re "\.size\s\+_function,\s*.-_function"
}

@test ".type not generated for function" {
  run ${XCC} <<SRC
void function(void){}
SRC

  assert_output_excludes_re "\.type\s\+_function,\s*@function"
}

@test ".ident not generated" {
  run ${XCC} <<SRC
SRC

  assert_output_excludes_re "\.ident\b"
}

@test ".c6xabi_attribute not generated" {
  run ${XCC} <<SRC
SRC

  assert_output_excludes_re "\.c6xabi_attribute\b"
}

@test "TI build attributes are generated" {
  run ${XCC} <<SRC
SRC

  assert_output_contains_re "\.battr\s\+\"TI\",\s*Tag_File,\s*1,\s*Tag_ABI_stack_align_needed(0)"
  assert_output_contains_re "\.battr\s\+\"TI\",\s*Tag_File,\s*1,\s*Tag_ABI_stack_align_preserved(0)"
  assert_output_contains_re "\.battr\s\+\"TI\",\s*Tag_File,\s*1,\s*Tag_Tramps_Use_SOC(1)"
}
