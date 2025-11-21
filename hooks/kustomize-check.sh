#!/bin/bash
set -o pipefail

exit_code=0
folder_changed=$(printf "%s\n" "$@" | xargs -n1 dirname | sort | uniq)

for folder in $folder_changed
do
  if [ "$folder" == "." ]; then
      continue
  fi

  KUSTOMIZATION_FILES=$(find "$folder" -type f \( -name '*.yaml' -o -name '*.yml' \) -exec grep -l 'kind: Kustomization' {} \; || echo "")
  if [ -n "$KUSTOMIZATION_FILES" ]; then
    for kustomization_file in $KUSTOMIZATION_FILES; do
      kustomization_dir=$(dirname "$kustomization_file")
      echo "Running kustomize build for directory: $kustomization_dir"
      if ! output=$(kubectl kustomize "$kustomization_dir" 2>&1); then
        echo "Error: kustomize build failed for directory: $kustomization_dir"
        echo "$output"
        exit_code=1
      fi
    done
  fi
done

exit $exit_code