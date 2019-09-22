#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nodePackages.node2nix

set -eu -o pipefail

rm -f node-env.nix
node2nix --nodejs-12 -i packages.json -o packages.nix -c composition.nix
