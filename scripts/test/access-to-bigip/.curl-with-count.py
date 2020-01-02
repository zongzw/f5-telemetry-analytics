
import requests
import sys
import time
import math
import datetime
import random
import eventlet

if len(sys.argv) != 2:
    print("%s <count>" % sys.argv[0])
    sys.exit(1)

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

while True:
    for n in range(0, int(sys.argv[1])):
        print(n)
        pool.spawn(request_once)
    time.sleep(1)

# pool.waitall()

