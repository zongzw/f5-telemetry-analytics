import eventlet
import subprocess
import requests
import random
import sys
import time
import datetime
import socket 
import math

logging_format = "timestamp: %s client-ip: %s host: %s user-agent: %s cookie: %s method: %s \
uri: %s username: %s content-type: %s server-ip: %s latency: %s resp-status: %s"
s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
logging_target = ("fluentd", 20001)

USER_AGENTS=(
    "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_7_0; en-US)",
    "AppleWebKit/534.21 (KHTML, like Gecko) Chrome/11.0.678.0 Safari/534.21",
    "Mozilla/5.0 (Windows; U; MSIE 9.0; Windows NT 9.0; en-US)",
    "Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:0.9.2)",
    "Gecko/20020508 Netscape6/6.1",
    "Mozilla/5.0 (X11;U; Linux i686; en-GB; rv:1.9.1)",
    "Gecko/20090624 Ubuntu/9.04 (jaunty) Firefox/3.5",
    "Opera/9.80 (X11; U; Linux i686; en-US; rv:1.9.2.3) Presto/2.2.15 Version/10.10"
)

def randx(arr):
    l = len(arr)
    r = random.randint(0, l-1)
    return arr[r]

def send_once():
    timestamp = datetime.datetime.now().strftime("%Y-%m-%dT%T.000Z")
    client_ip = '183.84.2.166'
    host = "10.250.17.133"
    user_agent = randx(USER_AGENTS)
    cookie = ""
    method = "GET"
    uri = "/"
    username = '-'
    content_type = "application/json"
    server_ip = "10.250.11.185"
    latency = str(random.randint(1, 40))
    resp_status = "200"

    logging_data = logging_format  % (
        timestamp, client_ip, host, user_agent, cookie, method,
        uri, username, content_type, server_ip, latency, resp_status
    )

    s.sendto(logging_data, logging_target)

# user_normal_behaviors = [
#     [ 
#         {'uri': '/login', 'latency': (20, 40), 'code': 401},
#     ],
#     [
#         {'uri': '/login', 'latency': (1, 20), 'code': 200},
#     ]
# ]

# send_once()

eventlet.monkey_patch()
pool = eventlet.GreenPool(20)

splits = 7200
max = 200
def count_total(index):
    global splits
    n = index % (splits + 1)
    t = (1.0 + math.sin(n * 2*math.pi / splits)) / 2.0
    print(n, int(t * max))
    return int(t * max)

endless = int(time.time())
while True:
    count = count_total(endless)
    for n in range(0, count): 
        pool.spawn(send_once)
        # time.sleep(0.05)
    time.sleep(1)

    endless += 1
