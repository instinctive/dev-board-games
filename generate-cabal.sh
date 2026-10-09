#!/usr/bin/env bash
set -euo pipefail
root=$(cd "$(dirname "$0")" && pwd)

gen() {
  local name=$(basename "$1" .dhall)
  local target="$root/$name/$name.cabal"
  local new=$(dhall text --file "$1")
  if [ ! -f "$target" ] || [ "$new" != "$(cat "$target")" ]; then
    printf '%s' "$new" > "$target"
    echo "updated $target"
  fi
}

if [ $# -gt 0 ]; then
  for name in "$@"; do
    gen "$root/${name%/}/${name%/}.dhall"
  done
else
  find . -name '*.dhall' ! -name generate.dhall -type f | while IFS= read -r f; do
    gen "$f"
  done
fi
