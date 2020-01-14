import math

splits = 3600 * 24


def count_sin(timestamp, max):
    n = timestamp % splits

    x = 2 * math.pi * n / splits  # 0 ~ 2*pi
    y = (1.0 + math.sin(x)) / 2.0
    
    return int(y * max)

def count_line(timestamp, max):
    n = timestamp % splits
    
    x = n / splits # 0 ~ 1
    y = x
    
    return int(y * max)

def count_const(timestamp, max):
    return max