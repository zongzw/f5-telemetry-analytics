import testlib

# socket
import socket
import random
import math
import sys
import signal
import testlib
import time

def sig_handler(signum, frame):
    print("Catched signal %d\n" % signum)
    testlib.send_logs.udp_socket.close()
    sys.exit(0)

signal.signal(signal.SIGINT, sig_handler)

if len(sys.argv) != 2:
    print("%s <maxps>\n" % sys.argv[0])
    sys.exit(1)

port = 20001
maxps = int(sys.argv[1])

def connect():
    testlib.send_logs.udp_connect('fluentd', port)

def logging_at(ts, count):

    for n in range(0, count):
        cmd = "testlib.mock_data.mock_logging_data_%s(%d, %d)" % (port, ts, count)
        d = eval(cmd)
        print(d)
        testlib.send_logs.send_udp(d)

        # time.sleep(0.01)

connect()

while True:
    n = int(time.time())
    count = testlib.counting.count_const(n, maxps)
    logging_at(n, count)
    time.sleep(1)

testlib.send_logs.udp_socket.close()

