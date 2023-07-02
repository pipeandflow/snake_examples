#! /bin/bash
set -x

origdir=$1
cd $origdir
guard=$2
if [[ ! -f $guard ]]; then
    # ensure that the guard is in place
    touch $guard
else
    exit 0
fi

let i=0
while true; do
    if [[ ! -f $guard ]]; then
        # The guard file was removed. We should break the loop
        exit 0
    fi
    touch results/file_$i
    let i=$i+1
    sleep 5
done 
