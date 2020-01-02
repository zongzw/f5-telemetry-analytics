import random
import timeutils

RESPCODES = [200, 200, 200, 200, 200, 200, 202, 202, 204, 204, 400, 401, 404, 410, 500, 503]
MAXCOUNT = 4000

def mock_logging_data_8083(ts, concurrency):
    size = random.randint(1, 1024)
    resp_code = RESPCODES[random.randint(0, len(RESPCODES)-1)]
    latency = random.randint(1, 5)
    latency = latency * 2 if size > 128 else latency
    latency = latency * 4 if concurrency > MAXCOUNT/2 else latency * 2 if concurrency > MAXCOUNT/4 else latency

    logdata = "%s: %d %d %d" %(timeutils.ts2str(ts), latency, size, resp_code)

    return logdata


def mock_logging_data_8084(ts, concurrency):
    size = random.randint(1, 1024)
    resp_code = RESPCODES[random.randint(0, len(RESPCODES)-1)]
    latency = random.randint(1, 5)
    latency = latency * 2 if size > 128 else latency
    latency = latency * 4 if concurrency > MAXCOUNT/2 else latency * 2 if concurrency > MAXCOUNT/4 else latency

    logdata = "%s: %d %d %d" %(timeutils.ts2str(ts), latency, size, resp_code)

    return logdata
