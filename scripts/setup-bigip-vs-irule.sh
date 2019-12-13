#!/bin/bash

cdir=`cd $(dirname $0); pwd`
command_prefix="curl -s -k -u admin:admin"

# env 
. /root/setup.rc # temp

virtual_name=`echo $BIGIP_VS_PATH | sed 's/\//~/g'`

vs_body=`$command_prefix -XGET https://$BIGIP_MGMT_IPADDR:$BIGIP_MGMT_PORT/mgmt/tm/ltm/virtual/$virtual_name`
echo $vs_body

rule_body="
{
    \"rules\": [
        \"/Common/f5-logging-irule\"
    ]
}
"

new_vs_body=`echo "$vs_body $rule_body" | jq -s '.[0] * .[1]'`

$command_prefix -XPUT -H "Content-Type: application/json" https://$BIGIP_MGMT_IPADDR:$BIGIP_MGMT_PORT/mgmt/tm/ltm/virtual/$virtual_name -d "$new_vs_body"
