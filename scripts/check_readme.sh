#! /bin/bash

PROJECT=darthjee/core_ext
VERSION=$(grep VERSION lib/$PROJECT/version.rb  | sed -e "s/.*'\(.*\)'/\1/g")

grep https://www.rubydoc.info/gems/darthjee-core_ext/$VERSION README.md
