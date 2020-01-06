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

# It's not a good idea to uncomment the following lines.
# instead, we should contact IT to apply for more disk.

# cluster.routing.allocation.disk.watermark.flood_stage 
# Controls the flood stage watermark. It defaults to 95%, meaning that Elasticsearch enforces a read-only index block on every index 
echo -n "Disabling Elasticsearch enforces a read-only index block on every inde ... "
curl -X PUT 'http://elasticsearch:9200/_cluster/settings' \
    -H 'Content-Type: application/json' \
    -d '{
        "transient": {
            "cluster.routing.allocation.disk.threshold_enabled": false
        }
    }'
echo

# When elastic reach its flood stage disk watermark, it will make indices readonly-allow-delete.
# blocked by: [FORBIDDEN/12/index read-only / allow delete (api)];"})
echo "Setting existing indices to read_only_allow_delete false ... "
curl -X PUT 'http://elasticsearch:9200/_all/_settings' \
    -H 'Content-Type: application/json' \
    -d '{
        "index": {
            "blocks": {
                "read_only_allow_delete": false
            }
        }
    }'
echo
