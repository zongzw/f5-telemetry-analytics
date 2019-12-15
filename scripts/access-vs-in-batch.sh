#!/bin/bash

if [ $# -ne 2 ]; then 
    echo "$0 <ip> <port>"
    exit 1
fi

cdir=`cd $(dirname $0); pwd`
. $cdir/../conf.d/setup.rc

docker exec SANDBOX bash -c "python /root/scripts/test/http-test.py $1 $2"