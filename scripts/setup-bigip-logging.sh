#!/bin/bash

cdir=`cd $(dirname $0); pwd`;

docker exec SANDBOX "/root/scripts/cmds-in-sandbox/create-logging-pool.sh"
docker exec SANDBOX "/root/scripts/cmds-in-sandbox/create-logging-irule.sh"
docker exec SANDBOX "/root/scripts/cmds-in-sandbox/setup-bigip-vs-irule.sh"
