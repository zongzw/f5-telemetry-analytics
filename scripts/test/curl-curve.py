
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

pool = eventlet.GreenPool(2000)

period = 60
def should_send(minute):
    global period
    n = minute % (period + 1)
    r = random.random()
    t = (1.0 + math.sin(n * 2*math.pi / period)) / 2.0
    print("%5s %.2f %.2f" % (r>t, r, t))
    return r > t

while True:
    # print()
    m = datetime.datetime.now().second
    if should_send(m):     
        pool.spawn(request_once)
        # time.sleep(0.05)


# pool.waitall()

