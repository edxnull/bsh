#!/bin/bash

for i in 1 2; do
  f=`mktemp ./foo$i.XXXX`
  echo "Content for temporary file number $i" > "$f"
  files="$files $f"
done

vim -p $files

echo "Removing files:"
for f in $files; do
  echo "$f"
done

rm $files
