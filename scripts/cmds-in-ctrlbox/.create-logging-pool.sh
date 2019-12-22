#!/bin/bash

cdir=`cd $(dirname $0); pwd`
workdir=$cdir/../..
command_prefix="curl -s -k -u admin:admin"

. $workdir/conf.d/.setup.rc # temp


# create pool on bigip
pool_name=f5-logging-pool

exists=`$command_prefix -XGET -s -o /dev/null -w "%{http_code}" \
    https://$BIGIP_MGMT_IPADDR:$BIGIP_MGMT_PORT/mgmt/tm/ltm/pool/~Common~$pool_name`

if [ "$exists" = "200" ]; then 
    echo "pool $pool_name already exists"
    exit 0;
fi

echo "creating pool $pool_name ..."
$command_prefix -XPOST -w "%{http_code}" -H "Content-Type: application/json" \
    https://$BIGIP_MGMT_IPADDR:$BIGIP_MGMT_PORT/mgmt/tm/ltm/pool -d "
    {
        \"kind\": \"tm:ltm:pool:poolstate\",
        \"name\": \"$pool_name\",
        \"monitor\": \"/Common/gateway_icmp\",
        \"members\": [
            {
                \"kind\": \"ltm:pool:members\",
                \"name\": \"$LOGGING_TARGET:20001\"
            }
	    ]
    }
"
