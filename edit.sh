#!/usr/bin/env bash
## http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

hx ~/Git/dotfiles/home.nix
git add .
git commit -m "$(date)"
git push
home-manager --flake . switch
