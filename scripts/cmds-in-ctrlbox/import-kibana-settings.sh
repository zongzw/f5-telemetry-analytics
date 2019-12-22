#!/bin/bash

cdir=`cd $(dirname $0); pwd`
workdir=$cdir/../..

ddir=$workdir/conf.d/kibana-exports
for n in `cd $ddir; ls *.json`; do 
    echo -n "Importing $n ... "
    curl -XPOST http://kibana:5601/api/kibana/dashboards/import \
        -s -o /dev/null \
        -w "%{http_code}" \
        -H "Content-Type: application/json" -H "kbn-xsrf: true" \
        -d @"$ddir/$n"
    echo
done
