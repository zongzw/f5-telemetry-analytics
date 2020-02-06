import requests
import sys
import os
import json
import subprocess
import time

import fluentd_buffer_size

curdir = os.getcwd()
rel_path = os.path.dirname(sys.argv[0])
if rel_path == '': rel_path = '.'
if not rel_path.startswith('/'): rel_path = os.path.join(curdir, rel_path)

workdir = os.path.join(rel_path, '../../..')

es_host = 'http://elasticsearch:9200'
disk_script_path = "%s/collect-disk-stats.sh" % (rel_path)

collectd = {}

try:
    r = subprocess.check_output(disk_script_path, shell=True)
    disk_data = json.loads(r)
    for k, v in disk_data.items():
        collectd[k] = v
except Exception as e:
    print("failed to get disk usage info: %s" % e.message)
    sys.exit(1)

for n in ['ltm-fluentd', 'errlogs']:
    try:
        index_pattern = n
        r = requests.get(
            "%s/%s-*/_stats" % (es_host, index_pattern),
        )
        docs_info = r.json()['_all']['total']['docs']
        index_count = docs_info['count'] - docs_info['deleted']
        collectd['%s-docs-count' % index_pattern] = index_count
    except Exception as e:
        print("failed to get index '%s''s stat: %s" % (index_pattern, e.message))
        sys.exit(1)

tag_name = 'ltm-fluentd'
datadir = os.path.join(workdir, 'data/fluentd', tag_name)
print datadir
workers_size = fluentd_buffer_size.get_subfolder_size(datadir)
collectd['fluentd_size_bytes'] = workers_size

datestr = time.strftime("%Y.%m.%d", time.gmtime())
timestr = time.strftime("%Y-%m-%dT%H:%M:%S.000Z", time.gmtime())

try:
    index_name = "healthcheck-%s" % datestr
    collectd['timestamp'] = timestr

    print("debug info: disk_data: %s" % (json.dumps(collectd, indent=2)))

    r = requests.post(
        "%s/%s/_doc" % (es_host, index_name), 
        headers={"Content-Type": "application/json"},
        json=collectd
    )
    print(r.json())
except Exception as e:
    print("failed to post doc to index %s: %s" % (index_name, e.message))


