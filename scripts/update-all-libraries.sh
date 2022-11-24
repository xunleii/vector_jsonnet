#!/usr/bin/env bash

# update-all-libraries.sh
#
# SUMMARY
#
#   Update all component libraries based on the online Vector documentation

SCRIPTS=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

"${SCRIPTS}/gen-component-library.sh" sources
"${SCRIPTS}/gen-component-library.sh" transforms
"${SCRIPTS}/gen-component-library.sh" sinks
