#!/usr/bin/env bash

# validate-examples.sh
#
# SUMMARY
#
#   Generate vector.toml file from JSONNET example and inject them into
#   a vector container.

set -e

if [ -z "$1" ]; then
  echo "usage: $0 <example_file.jsonnet>..."
  exit 1
fi

command -v jsonnet >/dev/null 2>&1 || { echo >&2 "jsonnet is required (https://github.com/google/jsonnet)... Aborting."; exit 1; }
command -v docker >/dev/null 2>&1 || { echo >&2 "docker is required (https://docs.docker.com/get-docker/)... Aborting."; exit 1; }

VECTOR_CONFIG_PATH=$(mktemp -d)

# compile given jsonnet files
echo "Compile JSONNET entry files"
for jsonnet_file in "$@"; do
  toml_file="${VECTOR_CONFIG_PATH}/$(basename "${jsonnet_file//.jsonnet/.toml}")"
  json_file="${VECTOR_CONFIG_PATH}/$(basename "${jsonnet_file//.jsonnet/.json}")"

  echo "- Compile ${jsonnet_file}"

  pushd "$(dirname "$jsonnet_file")" > /dev/null
    jsonnet "$(basename "$jsonnet_file")" > "${json_file}" || (echo "${jsonnet_file} is unvalid... need to fixit"; exit 1)
    sed -e 's|^\.json$|.toml|' "$(basename "${jsonnet_file}")" | jsonnet -S - > "${toml_file}" || (echo "${jsonnet_file} is unvalid... need to fixit"; exit 1)
  popd > /dev/null
done

echo
echo "Validate compiled settings"
# validate each files
for config_file in "${VECTOR_CONFIG_PATH}"/*; do
  echo "- Validate ${config_file}"
  docker run -v "${config_file}:/tmp/$(basename "${config_file}"):ro" timberio/vector:latest-alpine validate --no-environment --deny-warnings "/tmp/$(basename "${config_file}")"
  echo

  status=$?
  if [ $status -ne 0 ]; then exit $status; fi
done
