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


@test "global uninitialized char variable is defined" {
  run ${XCC} <<SRC
char varc;
SRC

  assert_output_contains_re "\.global\s\+_varc"
  assert_output_contains_re "\.bss\s\+_varc\s*,\s*1\s*,\s*1"
}

@test "global uninitialized short variable is defined" {
  run ${XCC} <<SRC
short vars;
SRC

  assert_output_contains_re "\.global\s\+_vars"
  assert_output_contains_re "\.bss\s\+_vars\s*,\s*2\s*,\s*2"
}

@test "global uninitialized struct variable is defined" {
  run ${XCC} <<SRC
struct _s { short m; } vars;
SRC

  assert_output_contains_re "\.global\s\+_vars"
  assert_output_contains_re "_vars\s*:\s*\.usect\s\+\"\.far\"\s*,\s*2\s*,\s*2"
}

@test "global uninitialized array variable is defined" {
  run ${XCC} <<SRC
int vararr[5];
SRC

  assert_output_contains_re "\.global\s\+_vararr"
  assert_output_contains_re "_vararr\s*:\s*\.usect\s\+\"\.far\"\s*,\s*20\s*,\s*8"
}

@test ".ref is generated for external data symbol" {
  run ${XCC} <<SRC
extern const int xval;
int fun(void) { return xval; }
SRC

  assert_output_contains_re "\.ref\s\+_xval"
}

@test ".ref is generated for external code symbol" {
  run ${XCC} <<SRC
int xfun();
int fun(void) { return xfun(); }
SRC

  assert_output_contains_re "\.ref\s\+_xfun"
}
