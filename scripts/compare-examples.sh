#!/usr/bin/env bash

# compare-examples.sh
#
# SUMMARY
#
#   Converts TOML file in JSON and compares it with the result of the 
#   equivalent JSONNET file.

set -e

if [ -z "$1" ]; then
  echo "usage: $0 <example_file.toml>"
  exit 1
fi

DIFFTOOLS='colordiff'

command -v jsonnet >/dev/null 2>&1 || { echo >&2 "jsonnet is required (https://github.com/google/jsonnet)... Aborting."; exit 1; }
command -v yj >/dev/null 2>&1 || { echo >&2 "yj is required (https://github.com/sclevine/yj)... Aborting."; exit 1; }
command -v $DIFFTOOLS >/dev/null 2>&1 || { DIFFTOOLS='diff'; }

TOML_FILE="$1"
JSONNET_FILE="${1%.toml}.jsonnet"

JSON_A="$(mktemp)"
cat "${TOML_FILE}" | yj -tj | jq '.' > "${JSON_A}" 

JSON_B="$(mktemp)"
jsonnet "${JSONNET_FILE}" | jq '.' > "${JSON_B}"

${DIFFTOOLS} -u "${JSON_A}" "${JSON_B}"

# # download config/vector.spec.toml from Github
# VECTOR_SPEC="$(mktemp)"
# curl -s https://raw.githubusercontent.com/timberio/vector/master/config/vector.spec.toml > ${VECTOR_SPEC}

# cat << EOF > "vector.$1.libsonnet"
# {
#   $(cat ${VECTOR_SPEC} | grep -i "# $1 " | sed 's|#|//|')
#   $1:: {
#     fn(type, o):: {kind:: '$1', type: type} + o,
#     $(cat ${VECTOR_SPEC} | grep --no-group-separator -B1 -P "^\[$1." | sed "s/\[$1.\(.*\)\]/    \1(o):: self.fn('\1', o),/" | sed "s|#|\n    //|")
#   },
# }
# EOF
