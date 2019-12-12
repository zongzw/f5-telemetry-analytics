import eventlet
eventlet.monkey_patch()
import requests
import random
USER_AGENTS = (
    "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_7_0; en-US)",
    "AppleWebKit/534.21 (KHTML, like Gecko) Chrome/11.0.678.0 Safari/534.21",
    "Mozilla/5.0 (Windows; U; MSIE 9.0; Windows NT 9.0; en-US)",
    "Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:0.9.2)",
    "Gecko/20020508 Netscape6/6.1",
    "Mozilla/5.0 (X11;U; Linux i686; en-GB; rv:1.9.1)",
    "Gecko/20090624 Ubuntu/9.04 (jaunty) Firefox/3.5",
    "Opera/9.80 (X11; U; Linux i686; en-US; rv:1.9.2.3) Presto/2.2.15 Version/10.10"
)

# DOMAIN = "http://nginx-website.com"
DOMAIN = "http://10.250.17.132:80"
SOURCE = ['.'.join((str(random.randint(1,254)) for _ in range(4))) for _ in range(100)]

for n in SOURCE:
    if n.startswith('192.') or n.startswith('127.') or n.startswith('10.'):
        SOURCE.remove(n)

print(SOURCE)
def fetch(num):
    spoof_src = random.choice(SOURCE)
    user_agent = random.choice(USER_AGENTS)
    
    headers = {'X-Forwarded-For':spoof_src, 'User-Agent':user_agent}
    r = requests.get(DOMAIN, headers = headers, timeout=20)
    
    return r

pool = eventlet.GreenPool(10)

for r in range(50):
    pool.spawn(fetch, r)

pool.waitall()
