#!/usr/bin/env bash
## http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

cd "$(dirname "$0")"
git pull || echo "git pull failed"
hx ./flake.nix
git add .
git commit -m "$(date)" || echo "git commit failed"
home-manager --flake .#$(whoami)@$(hostname -s) switch -b backup-$RANDOM --show-trace
git push || echo "git push failed"
