import requests
import sys

kibana_uri = 'http://localhost:5601/app/kibana'

try:
    resp = requests.get(kibana_uri)
except Exception as e:
    print("Failed to get %s: %s" % (kibana_uri, e.message))
    sys.exit(1)
else:    
    if resp.status_code == 200:
        sys.exit(0)
    else:
        print("kibana response with: %s" % resp.reason)
        sys.exit(1)
