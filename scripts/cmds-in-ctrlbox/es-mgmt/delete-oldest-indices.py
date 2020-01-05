import requests
import json
import subprocess
import sys
import os

curdir = os.getcwd()
rel_path = os.path.dirname(sys.argv[0])

es_host = 'http://elasticsearch:9200'
disk_script_path = "%s/%s/collect-disk-stats.sh" % (curdir, rel_path)
# '/root/workdir/scripts/cmds-in-ctrlbox/es-mgmt/collect-disk-stats.sh'

es_rest_data = None
disk_data = None

try:
    uri = "%s/http-fluentd-*/_stats" % es_host

    r = requests.get(uri)
    jdata = r.json()

    es_rest_data = {
        "docs": jdata['_all']['total']['docs']['count'],
        'store': jdata['_all']['total']['store']['size_in_bytes'] / 1024 / 1024,
        'indices': sorted(jdata['indices'].keys())
    }

except Exception as e:
    print("failed to get es rest data: %s" % e.message)
    sys.exit(1)

try:
    r = subprocess.check_output('./collect-disk-stats.sh', shell=True)
    disk_data = json.loads(r)

except Exception as e:
    print("failed to get disk usage info: %s" % e.message)
    sys.exit(1)

print("debug info: es_rest_data: %s, disk_data: %s" % (json.dumps(es_rest_data, indent=2), json.dumps(disk_data, indent=2)))

min_avail_rate = 10
avail_rate = int(100*disk_data['avail_size_m']/disk_data['total_size_m'])
if avail_rate < min_avail_rate:
    print("disk available %d%% is above %d%%, going to delete old indices.." % (avail_rate, min_avail_rate))

    oldest_index = es_rest_data['indices'][0]
    print("going to delete index %s" % oldest_index)
    try:
        uri = "%s/%s" % (es_host, oldest_index)
        r = requests.delete(uri)
        deleted = r.json()
        print("deleted %s: %s" %(oldest_index, json.dumps(deleted)))
    except Exception as e:
        print('failed to delete %s: %s' % (oldest_index, e.message))
