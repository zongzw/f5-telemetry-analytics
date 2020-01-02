#!/bin/bash 

# cdir=`cd $(dirname $0); pwd`
# workdir=$cdir/../..

echo "Checking td-agent configuration changes ... "
confpath=/etc/td-agent/fluentd

md5bin=`which md5sum`
(
    cd $confpath
    md5file=.confs.md5
    md5=`find . -name "*.conf" -exec $md5bin {} \; | $md5bin | grep -oE "[a-z0-9]{32}"`
    if [ ! -f $md5file -o "`cat $md5file`" != "$md5" ]; then
        echo "Reloading td-agent ... "
        echo $md5 > $md5file
        /etc/init.d/td-agent reload
    fi
)
