#!/usr/bin/env bash
## http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

hx home.nix
home-manager --flake . switch
git add .
git commit -m "$(date)"
git push
