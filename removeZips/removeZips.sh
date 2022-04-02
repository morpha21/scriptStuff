#!/bin/bash

path=$1

for zip in $path/*.zip;
do
    folder=${zip%".zip"}
    [ -d "$folder" ] && rm "$folder.zip" || echo "something went wrong"
done
