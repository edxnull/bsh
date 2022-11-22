#!/bin/bash

# A hacky way to get pkg.func usage stats within golang source.

<<'###'
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
    exit 0
fi

GOP=$1
PKG=$2 

echo -n "" > out.txt
for x in `go doc -short $PKG | cut -d "(" -f 1 | cut -d " " -f 2`; do 
    if [[ $PKG == *"."* ]]; then
        echo $PKG $(grep -RhnIo "$PKG" $GOP | wc -l) > out.txt ; break
    else
        echo $PKG.$x `grep -RhnIo "$PKG.$x" $GOP | wc -l` >> out.txt; 
    fi
done

cat out.txt | sort -k2 -n -r
rm out.txt
