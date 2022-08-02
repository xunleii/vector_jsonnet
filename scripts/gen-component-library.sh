#!/usr/bin/env bash

# gen-component-library.sh
#
# SUMMARY
#
#   Generates libsonnet for each component groups. This generation is based
#   on the Vector documentation, available on https://vector.dev/components/

set -e

if [ -z "$1" ]; then
  echo "usage: $0 <component_type>"
  exit 1
fi

# list all components from vector documentation website
VECTOR_COMPONENTS=$(curl -s https://vector.dev/docs/reference/configuration/$1/ | htmlq 'div.grid>div>a')
VECTOR_COMPONENT_JSONNET=""

lines=$(wc -l <<<"${VECTOR_COMPONENTS}")
num_components=$((lines / 2))

echo "[OK] $num_components '$1' components found"

# for each component badge, generate the wrapping
while IFS= read -r ignore; do
  read -r component
  component_name="$(htmlq 'span:last-child' -t <<<"${component}")"
  component_desc="$(htmlq 'div:last-child' -t <<<"${component}")"

  echo -n "[  ] Fetch component ${component_name}"

  # if no description available on the link title, use the component page to generate description
  if [ -z "${component_desc}" ]; then
    link="$(htmlq '.vector-component' -a href <<<"${component}")"

    component_desc="$(curl -s https://vector.dev"${link}" | htmlq 'article>.markdown:first-of-type>p:first-of-type' -t | tr '\n' ' ' | sed 's/[[:blank:]]*$//')"
  fi

  VECTOR_COMPONENT_JSONNET+=$(cat <<EOC


    // $component_desc
    $component_name(o={}):: self.fn('$component_name', o),

EOC
  )

  echo -e "\r[OK] Fetch component ${component_name}"

done <<< "${VECTOR_COMPONENTS}"

# update/generate libsonnet component file
cat << EOF > "vector.$1.libsonnet"
{
  $1:: {
    fn(type, o):: { kind:: '$1', type: type } + o,${VECTOR_COMPONENT_JSONNET}
  },
}
EOF

echo "[OK] Generates 'vector.$1.libsonnet'"
