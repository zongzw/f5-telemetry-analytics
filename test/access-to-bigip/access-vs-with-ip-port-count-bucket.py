import eventlet
import subprocess
import requests
import random
import sys
import time

if len(sys.argv) != 5:
    print("%s <ipaddress> <port> <count> <concurrency>" % sys.argv[0])
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
#     return subprocess.check_output(['bash', '-c', '. /root/workdir/conf.d/.setup.rc && echo $FAKE_BIGIP_VS_IPADDR']).strip()

DOMAIN = "http://%s:%s" % (sys.argv[1], sys.argv[2])
SOURCE = ['.'.join((str(random.randint(1,254)) for _ in range(4))) for _ in range(100)]

# print([10, 172, 192] + range(224, 256) )
for n in SOURCE:
    for m in [10, 172, 192 ] + range(224, 256):
        if n.startswith("%d." % m):
            # print("removing %s" % n)
            SOURCE.remove(n)

# print(SOURCE)

count = 0
failed = 0
total_time = 0
def request_once():
    global failed
    global count
    global total_time

    spoof_src = random.choice(SOURCE)
    user_agent = random.choice(USER_AGENTS)
    
    headers = {'X-Forwarded-For':spoof_src, 'User-Agent':user_agent}
    try:
        stime = time.time()
        requests.get(DOMAIN, headers = headers, timeout=20)

    except Exception as e:
        failed +=1;
        print("failed to connect %s: %s" % (DOMAIN, e.message))
    finally:
        count += 1;
        etime = time.time()
        total_time += etime - stime
        if count % 1000 == 0:
            print("count_total: %d, count_failed: %d, time_total: %f, time_average: %f" % (count, failed, total_time, total_time/count))

pool = eventlet.GreenPool(int(sys.argv[4]))

# for r in range(500):
#     print(r)
#     pool.spawn(fetch, r)

while count < int(sys.argv[3]):
    pool.spawn(request_once)

pool.waitall()

print("result: count_total: %d, count_failed: %d, time_total: %f, time_average: %f" % (count, failed, total_time, total_time/count))
