#!/usr/bin/env bash

# validate-examples.sh
#
# SUMMARY
#
#   Generate vector.toml file from JSONNET example and inject them into 
#   a vector container.

set -e

if [ -z "$1" ]; then
  echo "usage: $0 <example_file.toml>"
  exit 1
fi

command -v jsonnet >/dev/null 2>&1 || { echo >&2 "jsonnet is required (https://github.com/google/jsonnet)... Aborting."; exit 1; }
command -v docker >/dev/null 2>&1 || { echo >&2 "docker is required (https://docs.docker.com/get-docker/)... Aborting."; exit 1; }

VECTOR_TOML=$(mktemp)

pushd $(dirname $1) > /dev/null
  sed -e 's|^\.json$|.toml|' $(basename $1) | jsonnet -S - > ${VECTOR_TOML} || (echo "$1 is unvalid... need to fixit"; exit 1)
popd > /dev/null

docker run -v ${VECTOR_TOML}:/etc/vector/vector.toml:ro timberio/vector:latest-alpine validate 

status=$?
if test $status -eq 0
  then echo "$1 is valid"
  else echo "$1 is unvalid... need to fixit"
fi

exit $status