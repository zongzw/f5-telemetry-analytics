import time

timestamp = time.time()
strfmt = '%Y-%m-%dT%H:%M:%S.000Z'
timetuple = time.gmtime(timestamp)
timestr = time.strftime(strfmt, timetuple)

# os.system
# import os
# os.system("echo %s: zongzw $$ > /dev/tcp/fluentd/8081" % timestr)

# socket
import socket
import random
import math
import sys

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
h = socket.gethostbyname('fluentd')
s.connect((h, 8082))
# def logging_once():
#     global s
#     s.send("%s: zongzhaowei\n" % timestr)
# s.send("%s: zongzhaowei\n" % timestr)
# s.send("%s: zongzhaowei\n" % timestr)
# s.send("%s: zongzhaowei\n" % timestr)

RESPCODES = [200, 200, 200, 200, 200, 200, 202, 202, 204, 204, 400, 401, 404, 410, 500, 503]
MAXCOUNT = 4000


def ts2str(ts):
    return time.strftime(strfmt, time.gmtime(ts))

def str2ts(st):
    return int(time.mktime(time.strptime(st, strfmt)))

def logging_at(timestamp, count):

    for n in range(0, count):
        size = random.randint(1, 1024)
        resp_code = RESPCODES[random.randint(0, len(RESPCODES)-1)]
        latency = random.randint(1, 5)
        latency = latency * 2 if size > 128 else latency
        latency = latency * 4 if count > MAXCOUNT/2 else latency * 2 if count > MAXCOUNT/4 else latency

        logdata = "%s: %d %d %d\n" %(ts2str(timestamp), latency, size, resp_code)
        s.sendall(logdata)

def calc_count(timestamp):
    splits = 3600 * 24
    max = 5

    n = timestamp % (splits + 1)
    x = n * 2*math.pi / splits
    y = (1.0 + math.sin(x)) / 2.0
    
    return int(y * max)


start = "2019-12-14T00:00:00.000Z"
end = "2019-12-18T12:00:00.000Z"
nstart = str2ts(start)
nend = str2ts(end)
for n in range(nstart, nend):
    count = calc_count(n)
    if (n - nstart)* 100 % (nend - nstart) == 0:
        print("finished: %d, %d" % (int((n - nstart)* 100 / (nend - nstart)), count))
    logging_at(n,count)
    time.sleep(0.01)

s.close()