import eventlet
import subprocess
import requests
import random
import sys

if len(sys.argv) != 3:
    print("%s <ipaddress> <port>" % sys.argv[0])
    sys.exit(1)

eventlet.monkey_patch()

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

# DOMAIN = "http://nginx-website.com"

# def get_env(envstr):
#     return subprocess.check_output(['bash', '-c', '. /root/setup.rc && echo $FAKE_BIGIP_VS_IPADDR']).strip()

DOMAIN = "http://%s:%s" % (sys.argv[1], sys.argv[2])
SOURCE = ['.'.join((str(random.randint(1,254)) for _ in range(4))) for _ in range(100)]

print([10, 172, 192] + range(224, 256) )
for n in SOURCE:
    for m in [10, 172, 192 ] + range(224, 256):
        if n.startswith("%d." % m):
            print("removing %s" % n)
            SOURCE.remove(n)

print(SOURCE)

count=0
failed=0

def fetch():
    global failed
    spoof_src = random.choice(SOURCE)
    user_agent = random.choice(USER_AGENTS)
    
    headers = {'X-Forwarded-For':spoof_src, 'User-Agent':user_agent}
    try:
        r = requests.get(DOMAIN, headers = headers, timeout=20)
        return r
    except Exception as e:
        failed +=1;
        print("failed to connect %s: %s" % (DOMAIN, e.message))

pool = eventlet.GreenPool(20)

# for r in range(500):
#     print(r)
#     pool.spawn(fetch, r)

while True:
    print("count: %d, failed: %d" % (count, failed))
    count += 1
    pool.spawn(fetch)

pool.waitall()
