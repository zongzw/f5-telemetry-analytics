import random
import timeutils
import json
import uuid

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

USERNAMES = [
    'zongzw', 'andrew', 'andrewzong', 'zongzhaowei', 'kk', 'zz', 'xiong', 'zongzi', 'zong', 'zong',
    'sally', 'annie'
]

METHODS = [
    'GET', 'POST', 'DELETE', 'PUT', 'PATCH', 'GET', 'POST', 'PUT', 'GET'
]

URIS = [
    '/index.html',
    '/pages/344',
    '/images',
    '/',
    '/gsts.tar.gz',
    '/p/c8edab99173d',
    '/search',
    '/index.html',
    '/',
    '/search'
]

PORTS = [56002, 34563, 34345, 33746, 3344, 23345]

QNAMES = [
    'www.baidu.com',
    'httrack.website.com.cn',
    'google.com',
    'www.myf5.net'
]

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
        # "client-ip": "10.250.11.24",
        "host": "bigip-vs-server",
        "user-agent": user_agent,
        "cookie": "",
        "method": random.choice(METHODS),
        "uri": random.choice(URIS),
        "username": random.choice(USERNAMES),
        "content-type": "application/json",
        "server-ip": rand_dest,
        "latency": random.randint(1, 20),
        "resp-status": random.choice(RESPCODES),
        "sender": "zongzw %0d" % random.randint(0, 100),
        "stdout": "OK",

        'vs_name': random.choice(['/Common/vs-l4-84', '/Common/vs-l7-80']),
        'client_remote_port': random.choice([56002, 34563, 34345, 33746, 3344, 23345]),
        'client_local': 'bigip-clientside-ip',
        'server_local': 'bigip-serverside-ip',
        'server_local_port': random.choice([84, 80]),
        'server_remote': rand_dest,
        'server_remote_port': random.choice([84, 80]),
        'delay_type': random.choice(['svr-pkts-delay', 'init-delay', 'HS-delay']),
        'delay_value': random.randint(1, 10),
        'cdnumber': random.randint(1, 4)
    }
    
    return json.dumps(jdata)

HOSTNAMES = ['8bc234-245dacd.bigip.local', '58db82ad-2452badd.bigip.local']
def mock_logging_data_20002(ts, concurrency):

    rand_src = random.choice(SOURCES)
    user_agent = random.choice(USER_AGENTS)
    rand_dest = random.choice(DESTINATIONS)
    jdata = {
        "timestamp": timeutils.ts2str(ts),
        "clientip": rand_src,
        'clientport': random.choice(PORTS),
        'queryid': "%x" % random.randint(0, 100000),
        'origin': random.choice(QNAMES),
        'status': random.choice(['OK', 'FAILED']),
        
        "stdout": "OK"
    }

    def rand_request():
        d = {
            "data_type": 'request',
            "F5hostname": random.choice(HOSTNAMES),
            "viewname": random.choice(['aaa', 'bbb', 'none', 'none']),
            'listenervs': rand_dest,
            'queryname': random.choice(QNAMES),
            'querytype': random.choice(['A', 'AAAA', 'MX']),
            'routedomain': random.randint(1, 10)
        }
        return d

    def rand_response():
        d = {
            "data_type": 'response',
            "F5Reponsehostname": random.choice(HOSTNAMES),
            "responsecode": random.choice(['OK', 'FAILED']),
            "responseflag": random.choice(['what', 'is', 'a', 'flag', 'qr']),
            'responsename': random.choice(HOSTNAMES),
            'answer': random.choice(SOURCES)
        }

        if random.randint(0, 10) > 5: 
            d['emptyresponse'] = 'yes' 
        if random.randint(0, 10) > 5:
            d['iswideip'] = 'no'

        return  d
    
    f = random.choice([rand_request, rand_response])
    jd = f()

    jdata = dict(jdata.items() + jd.items())
    return json.dumps(jdata)
    