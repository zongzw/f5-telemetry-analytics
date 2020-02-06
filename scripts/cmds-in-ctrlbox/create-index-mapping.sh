#!/bin/bash 

if [ $# -eq 1 ]; then
  future_n=$1
fi 

cdir=`cd $(dirname $0); pwd`
workdir=$cdir/../..
# logpath=$workdir/logs/"$(basename $0).`date +%s`.log"

host_endpoint="http://elasticsearch:9200"

index_home=$workdir/conf.d/elasticsearch/index

echo -n "Setting read_only_allow_delete to false ... "
curl -X PUT -s -w "%{http_code}" -H "Content-Type: application/json" $host_endpoint/_settings \
  -d '{ "index": { "blocks": { "read_only_allow_delete": "false" } } }'
echo

function get_n_hour_further_datestr() {
  h=$1
  if [ "x$h" = "x" ]; then h=0; fi
  curhour=`date +%H`
  curdate=`date +%Y%m%d`
  echo `date -d "$curdate $curhour $h hour" +%Y.%m.%d`
}

(
  cd $index_home
  timestr=`get_n_hour_further_datestr $future_n`
  for n in `ls`; do 
    index_name=$n-$timestr
    response=`curl -s -o /dev/null $host_endpoint/$index_name -w "%{http_code}"`
    if [ "$response" != "200" ]; then
      echo -n "Creating index: $index_name ... "
      curl -s -w "%{http_code}" \
        -H "Content-Type: application/json" \
        -X PUT $host_endpoint/$index_name -d '
          {
            "settings": {
              "index": {
                "number_of_shards": 3,
                "number_of_replicas": 0
              }
            }
          }
        '
      echo
    fi

    echo -n "Creating index: $index_name's mapping ... "

    # curl -X PUT -s -w "%{http_code}" -o /dev/null \
    curl -X PUT -s -w "%{http_code}" \
      -H "Content-Type: application/json" \
      $host_endpoint/$index_name/_mapping -d@$n
    echo
  done
)

# No elseplaces are using ltm-fluentd index alias.
# echo -n "Creating aliases for ltm-fluentd-* and errlogs-* ... "
# curl -XPOST -s -w "%{http_code}" -H "Content-Type: application/json" $host_endpoint/_aliases -d'
# {
#     "actions" : [
#         { "add" : { "index" : "ltm-fluentd-*", "alias" : "all-ltm-fluentd-alias" } },
#         { "add" : { "index" : "errlogs-*", "alias" : "all-errlogs-alias" } }
#     ]
# }'
# echo

