#!/bin/bash

cdir=`cd $(dirname $0); pwd`
command_prefix="curl -s -k -u admin:admin"

# env 

# check as3 container ok to work.
as3_response=`$command_prefix https://as3:443/mgmt/shared/appsvcs/info`
echo $as3_response | grep version
if [ $? -ne 0 ]; then 
    echo "***** AS3 reponse with error *****"
    echo $as3_response
    exit 1
fi

# deploy with as3
. /root/setup.rc # temp
env

body=`cat << EOF
{
    "class": "AS3",
    "action": "deploy",
    "targetHost": "$BIGIP_MGMT_IPADDR",
    "targetUsername": "$BIGIP_MGMT_USERNAME",
    "targetPassphrase": "$BIGIP_MGMT_PASSWORD",
    "declaration": {
        "class": "ADC",
        "schemaVersion": "3.0.0",
        "id": "container",
        "label": "Sample 1 in a container",
        "remark": "Simple HTTP application with RR pool",
        "Sample_container": {
            "class": "Tenant",
            "A1": {
                "class": "Application",
                "template": "http",
                "serviceMain": {
                "class": "Service_HTTP",
                "virtualAddresses": [
                    "$BIGIP_VS_IPADDR"
                ],
                "pool": "web_pool"
                },
                "web_pool": {
                "class": "Pool",
                    "monitors": [
                        "http"
                    ],
                "members": [{
                    "servicePort": 8080,
                    "serverAddresses": $BIGIP_VS_POOL
                }]
                }
            }
        }
    }
}
EOF
`

echo $body


$command_prefix -H "Content-Type: application/json" \
    -X POST https://as3:443/mgmt/shared/appsvcs/declare \
    -d "$body"

# check vs ok. 

