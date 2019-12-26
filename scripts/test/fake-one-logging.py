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
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
h = socket.gethostbyname('fluentd')
s.connect((h, 8084))
def logging_once():
    global s
    # s.send("%s: 10 20 200\n" % timestr)
    s.send("%s: 10 20 200\n" % timestr)
# s.send("%s: zongzhaowei\n" % timestr)
# s.send("%s: zongzhaowei\n" % timestr)
# s.send("%s: zongzhaowei\n" % timestr)

logging_once()
s.close()
