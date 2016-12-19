#!/usr/bin/env bats

load test_helper

CC=${BATS_TEST_DIRNAME}/../.local/bin/tic6x-none-coff-gcc
CFLAGS="-S -o /dev/stdout -xc -"
XCC="${CC} ${CFLAGS}"


@test ".size not generated for function" {
  run ${XCC} <<SRC
void function(void){}
SRC

  assert_output_excludes_re ".size\w+function,\w+.-function"
}
