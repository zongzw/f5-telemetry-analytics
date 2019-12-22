#!/bin/bash

use_irule=0
if [ $# -eq 1 -a "$1" = 'irule' ]; then
    use_irule=1
fi 

cdir=`cd $(dirname $0); pwd`;
cmdsfolder=/root/workdir/scripts/cmds-in-ctrlbox

docker exec CTRLBOX "$cmdsfolder/.create-logging-pool.sh"

if [ $use_irule -eq 0 ]; then 
    docker exec CTRLBOX "$cmdsfolder/.create-logging-profile.sh"
    docker exec CTRLBOX "$cmdsfolder/.setup-bigip-vs-profile.sh"
else
    docker exec CTRLBOX "$cmdsfolder/.create-logging-irule.sh"
    docker exec CTRLBOX "$cmdsfolder/.setup-bigip-vs-irule.sh"
fi
