#!/usr/bin/env bash
## http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

cd "$(dirname "$0")"
$EDITOR ./flake.nix
git add .
git commit -m "$(date)"
home-manager --flake .#$1 switch
git push
