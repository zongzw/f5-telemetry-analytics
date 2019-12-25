import time

strfmt = '%Y-%m-%dT%H:%M:%S.000Z'

def ts2str(ts):
    return time.strftime(strfmt, time.gmtime(ts))

def str2ts(st):
    return int(time.mktime(time.strptime(st, strfmt)))

def last_n_days(num):
    end = int(time.time())
    start = int(end - 3600*24*num)
    return (start, end)

def last_n_minutes(num):
    end = int(time.time())
    start = int(end - 60*num)
    return (start, end)