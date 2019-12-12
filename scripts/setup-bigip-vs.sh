#!/bin/bash


# for first time:
# # ./setup-bigip-vs.sh
# {"version":"3.16.0","release":"6","schemaCurrent":"3.16.0","schemaMinimum":"3.0.0"}
# {"id":"83ef9b32-2cf3-45e7-a86d-7715e8b7d475","results":[{"message":"Installing service discovery components. The results of your request may be retrieved by sending a GET request to selfLink provided.","tenant":"","host":"","runTime":0,"code":0}],"declaration":{},"selfLink":"https://localhost/mgmt/shared/appsvcs/task/83ef9b32-2cf3-45e7-a86d-7715e8b7d475"}

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

irule_content=`cat $cdir/logging.irule | sed ':a;N;s/\n/\\\\n/g;ta' | sed 's/"/\\\\"/g'`
# echo $irule_content

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
        "sample_application": {
            "class": "Tenant",
            "A1": {
                "class": "Application",
                "template": "http",
                "serviceMain": {
                    "class": "Service_HTTP",
                    "virtualAddresses": [
                        "$BIGIP_VS_IPADDR"
                    ],
                    "pool": "web_pool",
                    "iRules": [
                        "logging_irule"
                    ]
                },
                "web_pool": {
                    "class": "Pool",
                    "monitors": [
                        "http"
                    ],
                    "members": [
                        {
                            "servicePort": 8080,
                            "serverAddresses": $BIGIP_VS_POOL
                        }
                    ]
                },
                "logging_pool": {
                    "class": "Pool",
                    "monitors": [
                        "icmp"
                    ],
                    "members": [
                        {
                            "servicePort": 20001,
                            "serverAddresses": $BIGIP_VS_POOL
                        }
                    ]
                },
                "logging_irule": {
                    "class": "iRule",
                    "iRule": "\n\n$irule_content"
                }
            }
        }
    }
}
EOF
`

# echo $body


$command_prefix -H "Content-Type: application/json" \
    -X POST https://as3:443/mgmt/shared/appsvcs/declare \
    -d "$body"

# check vs ok. 

