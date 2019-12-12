#!/bin/bash 

host_endpoint="http://elasticsearch:9200"
index_name=http-fluentd
response=`curl -s -o /dev/null $host_endpoint/$index_name -w "%{http_code}"`
if [ "$response" != "200" ]; then 
    curl -X PUT $host_endpoint/$index_name
fi

# {
#   "properties": {
#     "@timestamp": {
#       "type": "date"
#     },
#     "bigip_info": {
#       "type": "text"
#     },
#     "client_ip": {
#       "type": "ip"
#     },
#     "host": {
#       "type": "text"
#     },
#     "user-agent": {
#       "type": "keyword"
#     },
#     "cookie": {
#       "type": "keyword"
#     },
#     "server_ip": {
#       "type": "ip"
#     },
#     "status": {
#       "type": "text"
#     }, 
#     "city": {
#       "type": "text"
#     },
#     "geo": {
#       "type": "geo_point"
#     },
#     "country": {
#       "type": "text"
#     },
#     "country_name": {
#       "type": "text"
#     },
#     "postal_code": {
#       "type": "text"
#     },
#     "region_code": {
#       "type": "text"
#     },
#     "region_name": {
#       "type": "text"
#     }
#   }
# }
body=`cat << EOF
{
  "properties": {
    "timestamp": {
      "type": "date"
    },
    "bigip-info": {
      "type": "text"
    },
    "client-ip": {
      "type": "ip"
    },
    "host": {
      "type": "text"
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
      "type": "text"
    }, "city": {
      "type": "text"
    },
    "geo": {
      "type": "geo_point"
    },
    "country": {
      "type": "text"
    },
    "country_name": {   
      "type": "text"
    },
    "postal_code": {
      "type": "text"
    },
    "region_code": {
      "type": "text"
    },
    "region_name": {
      "type": "text"
    } 
  }
}
EOF
`

curl -X PUT -H "Content-Type: application/json" \
    $host_endpoint/$index_name/_mapping -d "$body"
