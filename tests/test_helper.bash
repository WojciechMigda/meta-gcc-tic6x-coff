flunk() {
  { if [ "$#" -eq 0 ]; then cat -
    else echo -e "$@"
    fi
  }
  return 1
}

assert_match() {
  out="${2:-${output}}"
  if [ ! $(echo "${out}" | grep -- "${1}") ]; then
    { echo "expected match: $1"
      echo "actual: $out"
    } | flunk
  fi
}

assert_output_contains() {
  local expected="$1"
  if [ -z "$expected" ]; then
    echo "assert_output_contains needs an argument" >&2
    return 1
  fi
  if [[ ${output} != *${expected}* ]]; then
    { echo "expected output to contain $expected"
      echo "actual: $output"
    } | flunk
  fi
  #echo "$output" | $(type -p ggrep grep | head -1) -F "$expected" >/dev/null || {
  #  { echo "expected output to contain $expected"
  #    echo "actual: $output"
  #  } | flunk
  #}
}

assert_output_excludes() {
  local unexpected="$1"
  if [ -z "$unexpected" ]; then
    echo "assert_output_excludes needs an argument" >&2
    return 1
  fi
  if [[ ${output} == *${unexpected}* ]]; then
    { echo "expected output to exclude $unexpected"
      echo "actual: $output"
    } | flunk
  fi
}

assert_output_contains_re() {
  local expected="$1"
  if [ -z "$expected" ]; then
    echo "assert_output_contains_re needs an argument" >&2
    return 1
  fi
  if ! ( echo "$output" | $(type -p ggrep grep | head -1) -G "$expected" >/dev/null )
  then
    { echo "expected output to contain $expected"
      echo "actual: $output"
    } | flunk
  fi
}

assert_output_excludes_re() {
  local unexpected="$1"
  if [ -z "$unexpected" ]; then
    echo "assert_output_excludes_re needs an argument" >&2
    return 1
  fi
  if ( echo "$output" | $(type -p ggrep grep | head -1) -G "$unexpected" >/dev/null )
  then
    { echo "expected output to exclude $unexpected"
      echo "actual: $output"
    } | flunk
  fi
}
