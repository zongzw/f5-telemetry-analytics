import testlib
import time

testlib.send_logs.udp_connect('fluentd', 20001)

# ts = testlib.timeutils.str2ts('2020-01-02T10:40:00.000Z')
ts = int(time.time())

# s1 = '2020-01-02T18:31:00.000Z'
# t1 = testlib.timeutils.str2ts(s1)
# s2 = testlib.timeutils.ts2str(t1)

log = testlib.mock_data.mock_logging_data_20001(ts, 1)
testlib.send_logs.send_udp(log)
print(log)
testlib.send_logs.udp_socket.close()

'''
{"username": "zongzw", "status": "200", "client-ip": "103.120.100.39", "timestamp": "2020-01-02T10:08:00.000Z", "host": "bigip-vs-server", "cookie": "", "latency": 4, "sender": "zongzw 17", "uri": "/", "user-agent": "Opera/9.80 (X11; U; Linux i686; en-US; rv:1.9.2.3) Presto/2.2.15 Version/10.10", "server-ip": "10.250.11.24", "content-type": "application/json", "method":"GET"}

'''
