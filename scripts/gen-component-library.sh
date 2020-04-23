#!/usr/bin/env bash

# gen-component-library.sh
#
# SUMMARY
#
#   Generates libsonnet for each component groups. This generation is based
#   on the config/vector.spec.toml file, available in the vector Github
#   repository.

set -e

if [ -z "$1" ]; then
  echo "usage: $0 <component>"
  exit 1
fi

# download config/vector.spec.toml from Github
VECTOR_SPEC="$(mktemp)"
curl -s https://raw.githubusercontent.com/timberio/vector/master/config/vector.spec.toml > ${VECTOR_SPEC}

cat << EOF > "vector.$1.libsonnet"
{
  $(cat ${VECTOR_SPEC} | grep -i "# $1 " | sed 's|#|//|')
  $1:: {
    fn(type, o):: { kind:: '$1', type: type } + o,
    $(cat ${VECTOR_SPEC} | grep --no-group-separator -B1 -P "^\[$1." | sed "s/\[$1.\(.*\)\]/    \1(o={}):: self.fn('\1', o),/" | sed "s|#|\n    //|")
  },
}
EOF
