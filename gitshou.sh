#!/bin/bash

# Ensure a commit hash is provided
if [ -z "$1" ]; then
  echo "Please provide a commit hash as an argument."
  exit 1
fi

commit_hash=$1
files=""

for file in $(git diff-tree --no-commit-id --name-only $commit_hash -r); do
  extension="${file##*.}"
  temp_file=$(mktemp ./$(uuidgen).$extension)
  git show "$commit_hash:$file" > "$temp_file"
  files="$files $temp_file"
done

echo "Created files: $files"

vim -p $files

for temp_file in $files; do
  rm -f "$temp_file"
done

echo "Temporary files have been removed."
