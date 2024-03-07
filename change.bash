#!/usr/bin/env bash
## http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

cd "$(dirname "$0")"
$EDITOR ./flake.nix
git add .
git commit -m "$(date)"
if [[ $# -eq 0 ]]; then
  home-manager --flake .#$(hostname -s)@$(whoami) switch
else
  home-manager --flake .#$1 switch
fi
git push
