#!/bin/bash

cdir=`cd $(dirname $0); pwd`;

docker exec SANDBOX "/root/scripts/cmds-in-sandbox/create-logging-pool.sh"

if true; then 
    docker exec SANDBOX "/root/scripts/cmds-in-sandbox/create-logging-profile.sh"
    docker exec SANDBOX "/root/scripts/cmds-in-sandbox/setup-bigip-vs-profile.sh"
else
    docker exec SANDBOX "/root/scripts/cmds-in-sandbox/create-logging-irule.sh"
    docker exec SANDBOX "/root/scripts/cmds-in-sandbox/setup-bigip-vs-irule.sh"
fi