import requests
import sys
import json

kibana_uri = 'http://localhost:5601/api/saved_objects/_find?type=dashboard&fields=id&fields=title'

try:
    resp = requests.get(kibana_uri)
except Exception as e:
    print("Failed to get %s: %s" % (kibana_uri, e.message))
    sys.exit(1)
else:    
    if resp.status_code == 200:
        jd = resp.json()
        if (jd['total'] != 0):
            print("total dashboards: %d" % jd['total'])
            sys.exit(0)
        else:
            print("kibana response with 0 dashboards: %s" % json.dumps(jd))
            sys.exit(1)
    else:
        print("kibana response with: %s" % resp.reason)
        sys.exit(1)
