#!/bin/bash

if [ $# -ne 2 ]; then 
    echo "$0 <dashboard_id> <target_directory>"
    exit 1
fi

curl -XGET \
    http://kibana:5601/api/kibana/dashboards/export?dashboard=$1 \
    -o $2/$1.json
    