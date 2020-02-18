#!/bin/bash

cdir=`cd $(dirname $0); pwd`
workdir=$cdir/../..

timeout=150
logpath=$workdir/logs/startup-`date +%Y.%m.%d.%H.%M.%S`.log

# echo -n "Waiting for es cluster to be ready ..."
# wait=0
# while true; do 
#     if [ $wait -ge $timeout ]; then 
#         echo "timeout for waiting for es readiness."
#         exit 1
#     fi
#     res_code=`curl http://elasticsearch:9200 -s -o /dev/null -w "%{http_code}"`
#     if [ "$res_code" = "200" ]; then 
#         echo " OK"
#         break; 
#     else 
#         echo -n "."
#     fi

#     wait=$(($wait + 1))
#     sleep 1
# done

# echo -n "Remove stale kibana tasks due to restart if exists ..."
# curl -XDELETE "http://elasticsearch:9200/.kibana_task_manager_*" -s -o /dev/null -w "%{http_code}"
# curl -XDELETE "http://elasticsearch:9200/.kibana_*" -s -o /dev/null -w "%{http_code}"
# echo

echo -n "Waiting for kibana to be ready ..."
wait=0
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

started=0
echo "Trying to start GoAccess (try max 10 times)..."
for n in {1..10}; do 
    curl "http://nginx" -s -o /dev/null && sleep 1 # to generate one piece of log to avoid empty access.log for goaccess
    goaccess $workdir/logs/nginx/access.log -o $workdir/logs/nginx/report.html \
        --date-format='"%d/%b/%Y"' --time-format='"%H:%M:%S"' --log-format=COMBINED \
        --real-time-html --daemonize # almostly failed to start goaccess
    sleep 5
    ps -ef | grep -v grep | grep goaccess > /dev/null 2>&1
    if [ $? -eq 0 ]; then break; fi
done

$cdir/import-kibana-settings.sh
$cdir/create-index-mapping.sh


# # It's not a good idea to uncomment the following lines.
# # instead, we should contact IT to apply for more disk.

# # cluster.routing.allocation.disk.watermark.flood_stage 
# # Controls the flood stage watermark. 
# # It defaults to 95%, meaning that Elasticsearch enforces a read-only index block on every index 
# echo -n "Disabling Elasticsearch read_only_allow_delete ... "
# curl -X PUT 'http://elasticsearch:9200/_cluster/settings' \
#     -s -w "%{http_code}" -H 'Content-Type: application/json' \
#     -d '{
#         "transient": {
#             "cluster.routing.allocation.disk.threshold_enabled": false
#         }
#     }'
# echo

# # When elastic reach its flood stage disk watermark, it will make indices readonly-allow-delete.
# # blocked by: [FORBIDDEN/12/index read-only / allow delete (api)];"})
# echo -n "Setting ES indices read_only_allow_delete false ... "
# curl -X PUT 'http://elasticsearch:9200/_all/_settings' \
#     -s -w "%{http_code}" -H 'Content-Type: application/json' \
#     -d '{
#         "index": {
#             "blocks": {
#                 "read_only_allow_delete": false
#             }
#         }
#     }'
# echo
