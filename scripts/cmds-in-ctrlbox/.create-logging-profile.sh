#!/bin/bash

# "timestamp: $timestamp client-ip: $client_ip host: $host user-agent: $user_agent cookie: $cookie method: $method uri: $uri username: $username content-type: $content_type server-ip: $server_ip latency: $latency resp-status: $resp_status"
# "%Y-%m-%dT%T.000Z"
# "zongzw timestamp: $DATE_YYYY-$DATE_MM-${DATE_DD}T${TIME_HMS}.000Z client-ip: $CLIENT_IP host: $Host user-agent: ${User-agent} cookie: $Cookie method: $HTTP_METHOD uri: $HTTP_URI username: $Username content-type: ${Content-Type} server-ip: $SERVER_IP latency: $RESPONSE_MSECS resp-status: $HTTP_STATCODE"

cdir=`cd $(dirname $0); pwd`
workdir=$cdir/../..
command_prefix="curl -s -k -u admin:admin"

. $workdir/conf.d/.setup.rc # temp

request_logging_profile_name="f5-request-logging-profile"
request_logging_profile_tmpl=`cat $workdir/conf.d/request-logging-template.profile`
request_logging_profile_body=`cat << EOF
{
    "kind": "tm:ltm:profile:request-log:request-logstate",
    "name": "$request_logging_profile_name",
    "partition": "Common",
    "fullPath": "/Common/$request_logging_profile_name",
    "defaultsFrom": "/Common/request-log",
    "logRequestLoggingErrors": "no",
    "logResponseByDefault": "yes",
    "logResponseLoggingErrors": "disabled",
    "proxyCloseOnError": "no",
    "proxyRespondOnLoggingError": "no",
    "proxyResponse": "none",
    "requestLogErrorPool": "none",
    "requestLogErrorProtocol": "mds-udp",
    "requestLogErrorTemplate": "none",
    "requestLogPool": "none",
    "requestLogProtocol": "mds-udp",
    "requestLogTemplate": "none",
    "requestLogging": "disabled",
    "responseLogErrorPool": "none",
    "responseLogErrorProtocol": "mds-udp",
    "responseLogErrorTemplate": "none",
    "responseLogPool": "/Common/f5-logging-pool",
    "responseLogProtocol": "mds-udp",
    "responseLogTemplate": "$request_logging_profile_tmpl",
    "responseLogging": "enabled"
}
EOF
`

echo $request_logging_profile_body

method=POST
profpath=""
exists=`$command_prefix -XGET -s -o /dev/null -w "%{http_code}" \
    https://$BIGIP_MGMT_IPADDR:$BIGIP_MGMT_PORT/mgmt/tm/ltm/profile/request-log/~Common~$request_logging_profile_name`
if [ "$exists" = "200" ]; then 
    echo "request logging profile $request_logging_profile_name already exists."
    echo "update logging profile $request_logging_profile_name"
    method=PUT
    profpath="/~Common~$request_logging_profile_name"
fi

$command_prefix -X$method -w "%{http_code}" -H "Content-Type: application/json" \
    https://$BIGIP_MGMT_IPADDR:$BIGIP_MGMT_PORT/mgmt/tm/ltm/profile/request-log$profpath -d "$request_logging_profile_body"
