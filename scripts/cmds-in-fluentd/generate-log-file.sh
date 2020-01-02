#!/bin/bash

if [ $# -ne 2 ]; then 
    echo "$0 <count> <filepath>"
    exit 1
fi

c=$1
p=$2

w=0
while [ $w -lt $c ]; do
    echo "`date +%Y-%m-%dT%T.000+0800`: $w `echo $w | md5sum`" >> $p
    w=$(($w + 1))
done
