#!/bin/bash

cdir=`cd $(dirname $0); pwd`
workdir=$cdir/../..
command_prefix="curl -s -k -u admin:admin"

. $workdir/conf.d/.setup.rc # temp

irule_content=`cat $workdir/conf.d/.logging.irule | sed ':a;N;s/\n/\\\\n/g;ta' | sed 's/"/\\\\"/g'`
# echo $irule_content

# create irule on bigip
irule_name=f5-logging-irule

exists=`$command_prefix -XGET -s -o /dev/null -w "%{http_code}" \
    https://$BIGIP_MGMT_IPADDR:$BIGIP_MGMT_PORT/mgmt/tm/ltm/rule/~Common~$irule_name`

if [ "$exists" = "200" ]; then 
    echo "irule $irule_name already exists"
    exit 0;
fi

echo "creating irule $irule_name ..."
$command_prefix -XPOST -w "%{http_code}" -H "Content-Type: application/json" \
    https://$BIGIP_MGMT_IPADDR:$BIGIP_MGMT_PORT/mgmt/tm/ltm/rule -d "
    {
        \"kind\": \"tm:ltm:rule:rulestate\",
        \"name\": \"$irule_name\",
        \"partition\": \"Common\",
        \"fullPath\": \"/Common/$irule_name\",
        \"apiAnonymous\": \"$irule_content\"
    }
    "
