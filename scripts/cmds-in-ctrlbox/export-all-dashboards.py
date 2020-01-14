# -*- coding: UTF-8 -*-

import requests
import os
import sys
import json

curdir = os.getcwd()
rel_path = os.path.dirname(sys.argv[0])
if rel_path == '': rel_path = '.'
if not rel_path.startswith('/'): rel_path = os.path.join(curdir, rel_path)
workdir = os.path.join(rel_path, '../..')

# print workdir

targetdir = "%s/conf.d/kibana-exports" % workdir
# print targetdir

kibana_endpoint = "http://kibana:5601"
get_ids_ep = "/api/saved_objects/_find?type=dashboard&fields=id&fields=title"
export_ep = "/api/kibana/dashboards/export?dashboard="

# print export_ep

try:
    r = requests.get("%s%s" % (kibana_endpoint, get_ids_ep))

    jr = r.json()

    # print jr
    ids = {}
    for n in jr['saved_objects']:
        ids[n['id']] = n['attributes']['title']

    print json.dumps(ids, indent=2)

except Exception as e:
    print("failed to get from kibana endpoint %s: %s" % (get_ids_ep, e.message))
    sys.exit(1)


for k, v in ids.items():
    try:
        r = requests.get("%s%s%s" % (kibana_endpoint, export_ep, k))
        exported = r.json()
        target_file = os.path.join(targetdir, "%s.json" % k)

        with open(target_file, 'w') as fw:
            print(target_file)
            fw.write(json.dumps(exported, indent=2))

    except Exception as e:
        print("failed to export dashboard with id %s under %s: %s" % (k, targetdir, e.message))