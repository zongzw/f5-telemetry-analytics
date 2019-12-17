
import requests
import sys
import time
import math
import datetime
import random
import eventlet

# if len(sys.argv) != 3:
#     print("%s <ipaddress> <port>" % sys.argv[0])
#     sys.exit(1)

eventlet.monkey_patch()

def request_once():
    DOMAIN = "http://%s:%s" % ('10.250.17.133', '80')
    headers = {
        'X-Forwarded-For': '183.84.2.166', 
        'User-Agent':'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_7_0; en-US)'
    }

    try:
        requests.get(DOMAIN, headers = headers, timeout=20)
    except Exception as e:
        print("failed to connect %s: %s" % (DOMAIN, e.message))
    finally:
        pass


# print(dir(datetime.datetime.now().minute))
# print(datetime.datetime.now().minute)

pool = eventlet.GreenPool(20)

period = 60
max = 80
def count_total(minute):
    global period
    n = minute % (period + 1)
    t = (1.0 + math.sin(n * 2*math.pi / period)) / 2.0
    print(n, int(t * max))
    return int(t * max)

while True:
    # print()
    m = datetime.datetime.now().second
    count = count_total(m)
    for n in range(0, count): 
        pool.spawn(request_once)
        # time.sleep(0.05)
    time.sleep(1)


# pool.waitall()

