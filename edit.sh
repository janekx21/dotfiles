#!/usr/bin/env bash
## http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

pushd ~/Git/dotfiles
hx home.nix
git add .
git commit -m "$(date)"
git push
home-manager --flake . switch
