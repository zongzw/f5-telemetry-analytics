#!/bin/bash 

cdir=`cd $(dirname $0); pwd`
workdir=$cdir/../..
# logpath=$workdir/logs/"$(basename $0).`date +%s`.log"

host_endpoint="http://elasticsearch:9200"

index_home=$workdir/conf.d/elasticsearch/index

echo -n "Setting read_only_allow_delete to false ... "
curl -X PUT -s -w "%{http_code}" -H "Content-Type: application/json" $host_endpoint/_settings \
  -d '{ "index": { "blocks": { "read_only_allow_delete": "false" } } }'
echo

(
  cd $index_home
  for n in `ls`; do 
    index_name=$n
    response=`curl -s -o /dev/null $host_endpoint/$index_name -w "%{http_code}"`
    if [ "$response" != "200" ]; then
      echo -n "Creating index: $index_name ... "
      curl -s -o /dev/null -w "%{http_code}" \
        -X PUT $host_endpoint/$index_name
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
