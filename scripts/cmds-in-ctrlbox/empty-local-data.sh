#!/bin/bash

cdir=`cd $(dirname $0); pwd`
workdir=$cdir/../..

if [ ! -d "$workdir/data" ]; then 
    echo "There is no data folder under $workdir"
    exit 1
fi

(
    cd $workdir/data
    for n in `find . -name .gitignore`; do 
        echo $n
    done
)

