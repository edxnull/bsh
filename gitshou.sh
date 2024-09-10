#!/bin/bash

# Ensure a commit hash is provided
if [ -z "$1" ]; then
  echo "Please provide a commit hash as an argument."
  exit 1
fi

commit_hash=$1
files=""

for file in $(git ls-tree -r --name-only $commit_hash); do
    if [[ "$file" == "bin/"* ]]; then
        continue
    fi
    temp_file=$(mktemp ./$(uuidgen | cut -c1-8).$(basename $file))
    git show "$commit_hash:$file" > "$temp_file"
    files="$files $temp_file"
done

echo "Created files: $files"

vim -p $files

for temp_file in $files; do
    rm -f "$temp_file"
done

echo "Temporary files have been removed."
