#!/bin/bash

cdir=`cd $(dirname $0); pwd`
workdir=$cdir/../..
command_prefix="curl -s -k -u admin:admin"

. $workdir/conf.d/.setup.rc # temp

virtual_name=`echo $BIGIP_VS_PATH | sed 's/\//~/g'`
logging_profile_name="f5-request-logging-profile"

exists=`$command_prefix -o /dev/null -s -w "%{http_code}" \
    -XGET https://$BIGIP_MGMT_IPADDR:$BIGIP_MGMT_PORT/mgmt/tm/ltm/virtual/$virtual_name/profiles/~Common~$logging_profile_name`
# echo $vs_profiles_body | python -m json.tool
if [ "$exists" = "200" ]; then 
    echo "profile $logging_profile_name has been associated to $virtual_name "
    exit 0
fi

logging_profile_body=`cat << EOF

{
    "kind": "tm:ltm:virtual:profiles:profilesstate",
    "name": "$logging_profile_name",
    "partition": "Common",
    "fullPath": "/Common/$logging_profile_name",
    "context": "all"
}

EOF
`

# new_vs_profiles_body_items=`echo "$vs_profiles_body $logging_profile_body" | jq -s '.[0].items + .[1].items'`
# new_vs_profiles_body=`echo $vs_profiles_body {"items": $new_vs_profiles_body_items} | jq -s .[0] * .[1]`

# echo "=========="
# echo $new_vs_profiles_body | python -m json.tool

$command_prefix -XPOST -H "Content-Type: application/json" \
    https://$BIGIP_MGMT_IPADDR:$BIGIP_MGMT_PORT/mgmt/tm/ltm/virtual/$virtual_name/profiles -d "$logging_profile_body"
