#! /bin/bash
set -x

let i=0
while true; do
    touch results/file_$i
    let i=$i+1
    sleep 5
done 
