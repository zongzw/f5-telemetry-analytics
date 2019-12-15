#!/bin/bash

use_irule=0
if [ $# -eq 1 -a "$1" = 'irule' ]; then
    use_irule=1
fi 

cdir=`cd $(dirname $0); pwd`;

docker exec SANDBOX "/root/scripts/cmds-in-sandbox/create-logging-pool.sh"

if [ $use_irule -eq 0 ]; then 
    docker exec SANDBOX "/root/scripts/cmds-in-sandbox/create-logging-profile.sh"
    docker exec SANDBOX "/root/scripts/cmds-in-sandbox/setup-bigip-vs-profile.sh"
else
    docker exec SANDBOX "/root/scripts/cmds-in-sandbox/create-logging-irule.sh"
    docker exec SANDBOX "/root/scripts/cmds-in-sandbox/setup-bigip-vs-irule.sh"
fi
