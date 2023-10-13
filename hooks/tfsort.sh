#!/usr/bin/env bash
set -eo pipefail

for file in "$@"; do
  if [[ -f "$file" ]]; then
    if [ -s "$file" ]; then
      echo "Sorting $file..."
      tfsort "$file"
    fi
  fi
done
