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
        trgd=`dirname $n`

        (
            cd $trgd
            curdir=`pwd`
            read -p "Ready to delete files under $curdir? (y/N):" Ready
            if [ x"$Ready" = "xy" ]; then 
                echo "Removing files under $curdir..."
                rm -rf $curdir/*
            fi
        )
    done
)
