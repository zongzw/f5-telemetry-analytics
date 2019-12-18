import socket 
import math
import eventlet


s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect(("fluentd", 8081))
def logging_once():
    global s
    s.send("2019-12-18T04:43:36.000Z: zongzhaowei\r\n")

logging_once()

s.close()