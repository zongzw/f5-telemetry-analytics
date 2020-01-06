import random
import timeutils
import json

RESPCODES = [200, 200, 200, 200, 200, 200, 202, 202, 204, 204, 400, 401, 404, 410, 500, 503]
MAXCOUNT = 4000

def mock_logging_data_8083(ts, concurrency):
    size = random.randint(1, 1024)
    resp_code = RESPCODES[random.randint(0, len(RESPCODES)-1)]
    latency = random.randint(1, 5)
    latency = latency * 2 if size > 128 else latency
    latency = latency * 4 if concurrency > MAXCOUNT/2 else latency * 2 if concurrency > MAXCOUNT/4 else latency

    logdata = "%s: %d %d %d" %(timeutils.ts2str(ts), latency, size, resp_code)

    return logdata

def mock_logging_data_8084(ts, concurrency):
    size = random.randint(1, 1024)
    resp_code = RESPCODES[random.randint(0, len(RESPCODES)-1)]
    latency = random.randint(1, 5)
    latency = latency * 2 if size > 128 else latency
    latency = latency * 4 if concurrency > MAXCOUNT/2 else latency * 2 if concurrency > MAXCOUNT/4 else latency

    logdata = "%s: %d %d %d" %(timeutils.ts2str(ts), latency, size, resp_code)

    return logdata

USER_AGENTS = (
    "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_7_0; en-US)",
    "AppleWebKit/534.21 (KHTML, like Gecko) Chrome/11.0.678.0 Safari/534.21",
    "Mozilla/5.0 (Windows; U; MSIE 9.0; Windows NT 9.0; en-US)",
    "Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:0.9.2)",
    "Gecko/20020508 Netscape6/6.1",
    "Mozilla/5.0 (X11;U; Linux i686; en-GB; rv:1.9.1)",
    "Gecko/20090624 Ubuntu/9.04 (jaunty) Firefox/3.5",
    "Opera/9.80 (X11; U; Linux i686; en-US; rv:1.9.2.3) Presto/2.2.15 Version/10.10"
)

SOURCES = ['.'.join((str(random.randint(1,254)) for _ in range(4))) for _ in range(100)]
DESTINATIONS = ['10.250.11.37', '10.250.11.24', '10.250.11.99', '10.250.11.37', '10.250.11.37']
# print([10, 172, 192] + range(224, 256) )
for n in SOURCES:
    for m in [10, 172, 192 ] + range(224, 256):
        if n.startswith("%d." % m):
            # print("removing %s" % n)
            SOURCES.remove(n)

def mock_logging_data_20001(ts, concurrency):
    #{
    # "timestamp": "$DATE_YYYY-$DATE_MM-${DATE_DD}T${TIME_HMS}.000Z", 
    # "client-ip": "${X-Forwarded-For}", 
    # "host": "$Host", 
    # "user-agent": "${User-agent}", 
    # "cookie": "$Cookie", 
    # "method": "$HTTP_METHOD", 
    # "uri": "$HTTP_URI", 
    # "username": "$Username", 
    # "content-type": "${Content-Type}", 
    # "server-ip": "$SERVER_IP", 
    # "latency": $RESPONSE_MSECS, 
    # "status": "$HTTP_STATCODE", 
    # "sender": "zongzw"
    # }

    rand_src = random.choice(SOURCES)
    user_agent = random.choice(USER_AGENTS)
    rand_dest = random.choice(DESTINATIONS)
    jdata = {
        "timestamp": timeutils.ts2str(ts),
        "client-ip": rand_src,
        "host": "bigip-vs-server",
        "user-agent": user_agent,
        "cookie": "",
        "method": "GET",
        "uri": "/",
        "username": "zongzw",
        "content-type": "application/json",
        "server-ip": rand_dest,
        "latency": random.randint(1, 20),
        "status": "200",
        "sender": "zongzw %0d" % random.randint(0, 100),
        "stdout": "OK"
    }
    
    


    return json.dumps(jdata)

'''
{
    "ts": "$DATE_YYYY-$DATE_MM-${DATE_DD}T${TIME_HMS}.000Z", 
    "timestamp": "$DATE_YYYY-$DATE_MM-${DATE_DD}T${TIME_HMS}.000Z", 
    "client-ip": "${X-Forwarded-For}", 
    "host": "$Host", 
    "user-agent": "${User-agent}", 
    "cookie": "$Cookie", 
    "method": "$HTTP_METHOD", 
    "uri": "$HTTP_URI", 
    "username": "$Username", 
    "content-type": "${Content-Type}", 
    "server-ip": "$SERVER_IP", 
    "latency": $RESPONSE_MSECS, 
    "status": "$HTTP_STATCODE", 
    "sender": "zongzw"
}
'''