#!/bin/bash

Red='\033[0;31m'
End='\033[0m'

for dir in *; do
    if [[ $(find $dir -type d -name ".git") ]]; then
        stat=$(git -C $dir status -s)
        if [[ $stat == *"M"* ]]; then
            echo $dir 
            echo -e "${Red}$stat${End}"
        elif [[ $stat == *"A"* ]]; then
            echo $dir
            echo -e "${Red}$stat${End}"
        fi
        ncommits=$(git -C $dir status | grep "by")
        if [[ $ncommits == *"by"* ]]; then
            echo -e "$dir: ${Red}$ncommits${End}"
        fi
    fi
done
