#!/bin/bash

if [ $# -ne 4 ]; then 
    echo "$0 <ip> <port> <count> <bucket>"
    exit 1
fi

docker exec CTRLBOX bash -c "python /root/workdir/test/access-to-bigip/access-vs-with-ip-port-count-bucket.py $1 $2 $3 $4"