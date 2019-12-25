import testlib

# socket
import socket
import random
import math
import sys
import time

RESPCODES = [200, 200, 200, 200, 200, 200, 202, 202, 204, 204, 400, 401, 404, 410, 500, 503]
MAXCOUNT = 4000

def mock_logging_data(ts):
    size = random.randint(1, 1024)
    resp_code = RESPCODES[random.randint(0, len(RESPCODES)-1)]
    latency = random.randint(1, 5)
    latency = latency * 2 if size > 128 else latency
    latency = latency * 4 if count > MAXCOUNT/2 else latency * 2 if count > MAXCOUNT/4 else latency

    logdata = "%s: %d %d %d" %(testlib.timeutils.ts2str(ts), latency, size, resp_code)

    return logdata


# def logging_at(timestamp, count):

#     for n in range(0, count):
#         size = random.randint(1, 1024)
#         resp_code = RESPCODES[random.randint(0, len(RESPCODES)-1)]
#         latency = random.randint(1, 5)
#         latency = latency * 2 if size > 128 else latency
#         latency = latency * 4 if count > MAXCOUNT/2 else latency * 2 if count > MAXCOUNT/4 else latency

#         logdata = "%s: %d %d %d\n" %(ts2str(timestamp), latency, size, resp_code)
#         s.sendall(logdata)


def connect_8082():
    testlib.send_logs.tcp_connect('fluentd', 8084)

def logging_at(ts, count):

    for n in range(0, count):
        d = mock_logging_data(ts)
        testlib.send_logs.send_tcp_in_bundle(d)
    
    while True:
        nts = int(time.time())
        if nts != int(ts):
            break
        else:
            time.sleep(0.01)

connect_8082()

(nstart, nend) = testlib.timeutils.last_n_days(1)
for n in range(nstart, nend):
    count = testlib.counting.count_sin(n, 200)
    if (n - nstart)* 100 % (nend - nstart) == 0:
        print("finished: %d, %d" % (int((n - nstart)* 100 / (nend - nstart)), count))
    logging_at(n,count)

testlib.send_logs.tcp_socket.close()

