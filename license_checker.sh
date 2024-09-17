#!/usr/bin/env bash

# Usage: ./license_checker.sh source_code_pattern
# Example: ./license_checker.sh '*.rb'
# This will search all .rb files, ignoring anything not tracked in your git tree

git ls-files -z $1 | xargs -0 -n 10 -I{} sh -c 'RES=$(head -n 3 "{}" | grep "Copyright 20[0-9][0-9] DeepL SE (https://www.deepl.com)\|Copyright 20[0-9][0-9] Daniel Herzog"); if [ ! "${RES}" ] ; then echo "Lacking copyright header in" "{}" ; fi'

