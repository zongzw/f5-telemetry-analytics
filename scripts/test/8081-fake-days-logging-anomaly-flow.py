import socket 
import math
import eventlet
import os
import datetime
import time
# s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
# s.connect(("fluentd", 8081))
# def logging_once():
#     global s
#     s.send("2019-12-18T04:43:36.000Z: zongzhaowei\r\n")

strfmt = '%Y-%m-%dT%H:%M:%S.000Z'
def logging_once(timestamp):
    timetuple = time.gmtime(timestamp)
    timestr = time.strftime(strfmt, timetuple)
    os.system("echo %s: $$ > /dev/tcp/fluentd/8081" % timestr)

start = "2019-12-15T22:00:00.000Z"
end = "2019-12-16T04:00:00.000Z"

def ts2str(ts):
    return int(time.strftime(strfmt, time.gmtime(ts)))

def str2ts(st):
    return int(time.mktime(time.strptime(st, strfmt)))



eventlet.monkey_patch()
pool = eventlet.GreenPool(20)


def count_total(index):
    splits = 3600
    max = 5

    n = index % (splits + 1)
    t = (1.0 + math.sin(n * 2*math.pi / splits)) / 2.0
    
    return int(t * max)

for n in range(str2ts(start), str2ts(end)):
    count = count_total(n)
    for m in range(0, count):
        pool.spawn(logging_once, n)



