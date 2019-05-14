#!/usr/bin/env

set -eu -o pipefail

#pushd tests

elm-test
elm-verify-examples
elm-analyse
elm-doc-preview --version

popd
