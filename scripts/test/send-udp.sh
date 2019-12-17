#!/bin/bash

timestamp=`date +%Y-%m-%dT%T.000Z`
client_ip='183.84.2.166'
host="10.250.17.133"
user_agent="annyyy"
cookie=""
method="GET"
uri="/"
username='-'
content_type="application/json"
server_ip="10.250.11.185"
latency=12
resp_status=200

data="\
timestamp: $timestamp \
client-ip: $client_ip \
host: $host \
user-agent: $user_agent \
cookie: $cookie \
method: $method \
uri: $uri \
username: $username \
content-type: $content_type \
server-ip: $server_ip \
latency: $latency \
resp-status: $resp_status\
"
echo "$data" > /dev/udp/fluentd/20001