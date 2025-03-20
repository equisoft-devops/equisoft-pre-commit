#!/bin/bash

# Get list of staged files related to terraform(excluding deleted ones)
staged_files=$(git diff --cached --name-only --diff-filter=d | grep -E '\.tf$|\.tfvars$|\.hcl$|\.yaml$|\.md$')

# Ensure we have files to check
if [[ -z "$staged_files" ]]; then
    echo "No staged files to check."
    exit 0
fi

bad_files=()

# Loop through each staged file
while IFS= read -r file; do

    # Skip empty files
    if [[ ! -s "$file" ]]; then
        continue
    fi

    # Check for double newlines
    if awk 'prev == "" && $0 == "" { found=1 } { prev=$0 } END { exit !found }' "$file"; then
        bad_files+=("$file")

        # Remove double newlines
        sed -i '' -E '/^$/N;/^\n$/D;' "$file"
    fi

done <<< "$staged_files"

# If double newlines within files are found, print the list of files and fail the commit
if [[ ${#bad_files[@]} -gt 0 ]]; then
    echo "The following staged files contained double newlines:"
    printf '%s\n' "${bad_files[@]}"
    exit 1
fi

exit 0
