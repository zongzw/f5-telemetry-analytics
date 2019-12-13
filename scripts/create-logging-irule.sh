#!/bin/bash

cdir=`cd $(dirname $0); pwd`
command_prefix="curl -s -k -u admin:admin"

. /root/setup.rc # temp

irule_content=`cat $cdir/logging.irule | sed ':a;N;s/\n/\\\\n/g;ta' | sed 's/"/\\\\"/g'`
# echo $irule_content

# create irule on bigip
$command_prefix -XPOST -H "Content-Type: application/json" \
    https://$BIGIP_MGMT_IPADDR:$BIGIP_MGMT_PORT/mgmt/tm/ltm/rule -d "
    {
        \"kind\": \"tm:ltm:rule:rulestate\",
        \"name\": \"f5-logging-irule\",
        \"partition\": \"Common\",
        \"fullPath\": \"/Common/logging_irule\",
        \"apiAnonymous\": \"$irule_content\"
    }
    "
