#!/bin/bash

# A hacky way to get pkg.func usage stats within golang source.

<<'###'
./usago.sh will grep all imports and sort | uniq them before printing out
./usago.sh $GOP "fs"

fs.File 205
fs.FileInfo 133
fs.PathError 100
fs.DirEntry 64
fs.FileMode 51
fs.FS 30
fs.ErrInvalid 13
fs.WalkDir 12
fs.ReadFile 10
fs.ValidPath 7
fs.ReadDirFile 7
fs.Glob 7
fs.WalkDirFunc 6
fs.SkipDir 3
fs.GlobFS 3
fs.StatFS 2
fs.ReadFileFS 2
fs.ReadDirFS 2
fs.SubFS 1

or alternatively you can use ./usago.sh $GOP "filepath.Join" and get filepath.Join 1125
###

if [ $# -ne 2 ]; then
    grep -h -r -A 100 'import (' . | sed -n '/^import/,/^)/p' | grep '"' | sed 's/^[[:space:]]*//; s/"//g' | sort -u
    exit 0
fi

GOP=$1
PKG=$2 

CMD=`go doc -short $PKG | sed 's/^[[:space:]]*//' | cut -d ' ' -f 2 | cut -d '(' -f 1`

max_length=$(printf '%s\n' "$CMD" |
             awk '{ print length }' |  # Get the length of each
             sort -rn |  # Sort numerically in descending order
             head -n1)  # Get the maximum length

max_length=$((max_length + 5))
format="%-${max_length}s %d"

declare -a results

for x in $CMD; do
    if [[ $PKG == *"."* ]]; then
        count=$(grep -RhnIo "$PKG" $GOP | wc -l)
        results+=("$(printf "$format" "$PKG" "$count")")
        break
    else
        count=$(grep -RhnIo "$PKG.$x" $GOP | wc -l)
        results+=("$(printf "$format" "$PKG.$x" "$count")")
    fi
done

IFS=$'\n' sorted=($(sort -k2 -n -r <<< "${results[*]}"))
printf '%s\n' "${sorted[@]}"
