#!/usr/bin/env bash
set -eo pipefail

# Note we don't use yq in this script for more compatibility with CI and dev environments

for file in "$@"; do
  if [[ -f "$file" ]]; then
    if [ -s "$file" ]; then
      kms_role=$(grep "role: arn:aws:iam::" "$file" | cut -d ":" -f 2-)
      if [ -z "$kms_role" ]; then
        echo "$file isn't encrypted with a KMS key"
        exit 1
      fi
      environment=$(dirname "$file" | awk -F/ '{print $1}')

      # Skip fluxcd directory
      if [[ "$environment" == "fluxcd" ]]; then
        continue
      fi

      if [[ ! "$kms_role" == *"$environment"* ]]; then
        echo "$file isn't encrypted with a good KMS key"
        exit 1
      fi
    fi
  fi
done
