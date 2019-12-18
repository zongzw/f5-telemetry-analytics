#!/bin/bash 

host_endpoint="http://elasticsearch:9200"
index_name=http-fluentd
response=`curl -s -o /dev/null $host_endpoint/$index_name -w "%{http_code}"`
if [ "$response" != "200" ]; then
    echo -n "create index: $index_name ... "
    curl -s -X PUT $host_endpoint/$index_name
    echo "done"
fi

body=`cat << EOF
{
  "properties": {
    "timestamp": {
      "type": "date"
    },
    "bigip-info": {
      "type": "text",
      "fielddata": true
    },
    "client-ip": {
      "type": "ip"
    },
    "host": {
      "type": "text",
      "fielddata": true
    },
    "user-agent": {
      "type": "keyword"
    },
    "cookie": {
      "type": "keyword"
    },
    "server-ip": {
      "type": "ip"
    },
    "status": {
      "type": "text",
      "fielddata": true
    }, 
    "city": {
      "type": "text",
      "fielddata": true
    },
    "geo": {
      "type": "geo_point"
    },
    "country": {
      "type": "text",
      "fielddata": true
    },
    "country_name": {   
      "type": "text",
      "fielddata": true
    },
    "postal_code": {
      "type": "text",
      "fielddata": true
    },
    "region_code": {
      "type": "text",
      "fielddata": true
    },
    "region_name": {
      "type": "text",
      "fielddata": true
    },
    "latency": {
      "type": "integer"
    },
    "method": {
      "type": "text",
      "fielddata": true
    },
    "uri": {
      "type": "text",
      "fielddata": true
    }
  }
}
EOF
`

echo -n "creating index: $index_name's mapping ..."
curl -X PUT -s -H "Content-Type: application/json" \
    $host_endpoint/$index_name/_mapping -d "$body"
echo " done"

index_name=ml-data
response=`curl -s -o /dev/null $host_endpoint/$index_name -w "%{http_code}"`
if [ "$response" != "200" ]; then
    echo -n "create index: $index_name ... "
    curl -s -X PUT $host_endpoint/$index_name
    echo "done"
fi

body=`cat << EOF
{
  "properties": {
    "timestamp": {
      "type": "date"
    },
    "message": {
      "type": "text",
      "fielddata": true
    }
  }
}
EOF
`

echo -n "creating index: $index_name's mapping ..."
curl -X PUT -s -H "Content-Type: application/json" \
    $host_endpoint/$index_name/_mapping -d "$body"
echo " done"