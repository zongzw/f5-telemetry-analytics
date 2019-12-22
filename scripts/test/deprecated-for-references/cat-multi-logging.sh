#!/bin/bash

datestr=`date +%Y-%m-%dT%T.000Z`
cat << EOF > /dev/tcp/fluentd/8081
$datestr: zongzw
$datestr: zongzhaowei
$datestr: andrewzong
EOF

