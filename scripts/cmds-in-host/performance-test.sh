#!/bin/bash

if [ $# -ne 4 ]; then 
    echo "$0 <ip> <port> <count> <bucket>"
    exit 1
fi

cmdsfolder=/root/workdir/scripts/cmds-in-ctrlbox
docker exec CTRLBOX "$cmdsfolder/.create-fake-bigip-vs.sh"
docker exec CTRLBOX "$cmdsfolder/.create-logging-pool.sh"

docker exec CTRLBOX "$cmdsfolder/.create-logging-profile.sh"
docker exec CTRLBOX "$cmdsfolder/.setup-bigip-vs-profile.sh"

# docker exec CTRLBOX "$cmdsfolder/create-logging-irule.sh"
# docker exec CTRLBOX "$cmdsfolder/setup-bigip-vs-irule.sh"

cdir=`cd $(dirname $0); pwd`
$cdir/access-vs-in-batch.sh $1 $2 $3 $4
# docker exec CTRLBOX bash -c ". /root/workdir/conf.d/.setup.rc && env && python /root/workdir/test/http-test.py $1 $2"


# solve: https://www.cnblogs.com/hcy-fly/p/7908324.html
# 1 ➜  Downloads curl -XPUT 'http://localhost:9200/bank/_mapping/account' -d '
# 2 {       
# 3   "properties": {
# 4         "state": {  
# 5             "type": "text",
# 6             "fielddata": true
# 7         }       
# 8     }         
# 9 }'
# bank是index、account是类型、state是你需要设置的text字段
# [esaggs] > Request to Elasticsearch failed: 
# {
#     "error": {
#         "root_cause": [
#             {
#                 "type": "illegal_argument_exception",
#                 "reason": "Fielddata is disabled on text fields by default. Set fielddata=true on [username] in order to load fielddata in memory by uninverting the inverted index. Note that this can however use significant memory. Alternatively use a keyword field instead."
#             }
#         ],
#         "type": "search_phase_execution_exception",
#         "reason": "all shards failed",
#         "phase": "query",
#         "grouped": true,
#         "failed_shards": [
#             {
#                 "shard": 0,
#                 "index": "ltm-fluentd",
#                 "node": "m9MKf5zbT7-Yp7F3a5Dmlw",
#                 "reason": {
#                     "type": "illegal_argument_exception",
#                     "reason": "Fielddata is disabled on text fields by default. Set fielddata=true on [username] in order to load fielddata in memory by uninverting the inverted index. Note that this can however use significant memory. Alternatively use a keyword field instead."
#                 }
#             }
#         ],
#         "caused_by": {
#             "type": "illegal_argument_exception",
#             "reason": "Fielddata is disabled on text fields by default. Set fielddata=true on [username] in order to load fielddata in memory by uninverting the inverted index. Note that this can however use significant memory. Alternatively use a keyword field instead.",
#             "caused_by": {
#                 "type": "illegal_argument_exception",
#                 "reason": "Fielddata is disabled on text fields by default. Set fielddata=true on [username] in order to load fielddata in memory by uninverting the inverted index. Note that this can however use significant memory. Alternatively use a keyword field instead."
#             }
#         }
#     },
#     "status": 400
# }