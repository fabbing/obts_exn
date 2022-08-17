#!/bin/bash
set -eu

filename=gdb.out

function escape() {
  local str=${1}

  echo ${str} | awk '{ gsub(/([#$_&{}_~^\\])/, "\\\\&"); print }'
}

function digit_to_letter() {
  local str=${1}

  # Yuck!
  echo ${str} | awk '{
    str = $0
    while (match(str, /^([^0-9]*)([0-9]+)(.*)$/, m) != 0) {
      num = strtonum(m[2])
      if (0 <= num && num <= 26) {
        printf "%s%c", m[1], (64 + num)
      }
      else {
        exit 1
      }
      str = m[3]
    }
    print str
  }'
}

function sanitize_var_name() {
  local name=${1}

  echo $(escape "$(digit_to_letter "${name}")")
}

function trim_backtrace() {
  local str=${1}

  echo "$str" \
    | awk '{ match($0, /.* <(.*)>/, m); print m[1] }' \
    | sed 's/^caml[^_]*__\([a-zA-Z_]*\)\(_[0-9]*\)\?+\([0-9]*\)$/\1+\3/'
}

function hex_var() {
  local name=${1}

  if (($# == 2)); then
    local version=${2}
    name="${name}${version}"
  fi
  name=$(sanitize_var_name "${name}")

  value=$(</dev/stdin)

  echo "\\hexToDecInto{\\${name}}{${value}}"
}

function var() {
  local name=${1}

  if (($# == 2)); then
    local version=${2}
    name="${name}${version}"
  fi
  name=$(sanitize_var_name "${name}")

  value=$(</dev/stdin)
  value=$(escape "${value}")

  echo "\\newcommand\\${name}{${value}}"
}

function addr_var() {
  local name=${1}

  name=$(sanitize_var_name "${name}")

  value=$(</dev/stdin)
  value=$(escape "$(trim_backtrace "${value}")")

  echo "\\newcommand\\${name}{${value}}"
}

function addr_array() {
  local name=${1}
  local line
  local entry

  name=$(sanitize_var_name "${name}")

  echo -n "\\newcommand\\${name}{"
  while read -r line; do 
    entry=$(escape "$(trim_backtrace "${line}")")
    echo -n "${entry} " # FIXME no space after last element
  done </dev/stdin
  echo "}"
}

function var_version() {
  local name=${1}
  local version

  read -r version

  var "${name}v${version}"
}

function hex_var_version() {
  local name=${1}
  local version

  read -r version

  hex_var "${name}v${version}"
}

function addr_var_version() {
  local name=${1}
  local version

  read -r version

  addr_var "${name}v${version}"
}

function addr_array_version() {
  local name=${1}
  local version

  read -r version

  addr_array "${name}v${version}"
}

echo "latex.sh = ${@}"

path=$(pwd)
file=$path/${filename}

# https://stackoverflow.com/questions/8818119/how-can-i-run-a-function-from-a-script-in-command-line
if declare -f "$1" >/dev/null
then
  # call arguments verbatim
  {
    "$@"
  } >>${file}
else
  # Show a helpful error
  echo "'$1' is not a known function name" >&2
  exit 1
fi
