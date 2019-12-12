#!/bin/bash 

host_endpoint="http://elasticsearch:9200"
index_name=http-fluentd

curl -X DELETE $host_endpoint/$index_name