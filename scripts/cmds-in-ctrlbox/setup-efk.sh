#!/bin/bash

cdir=`cd $(dirname $0); pwd`

wait=0
timeout=60

echo -n "Waiting for kibana to be ready ..."
while true; do 
    if [ $wait -ge $timeout ]; then 
        echo "timeout for waiting for kibana readiness."
        exit 1
    fi
    res_code=`curl http://kibana:5601/app/kibana -s -o /dev/null -w "%{http_code}"`
    if [ "$res_code" = "200" ]; then 
        echo " OK"
        break; 
    else 
        echo -n "."
    fi

    wait=$(($wait + 1))
    sleep 1
done

$cdir/import-kibana-settings.sh
$cdir/create-index-mapping.sh
