#!/usr/bin/env bash
## http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

cd "$(dirname "$0")"
git pull || echo "git pull failed"
nix flake update
git add .
git commit -m "$(date)"
if [[ $# -eq 0 ]]; then
  home-manager --flake .#$(whoami)@$(hostname -s) switch -b backup-$RANDOM
else
  home-manager --flake .#$1 switch
fi
git push || echo "git push failed"
