#!/bin/bash

cdir=`cd $(dirname $0); pwd`
workdir=$cdir/../..

es_data_dir=$workdir/data/elasticsearch

size_str=`du -sm $es_data_dir` # inline this line to size_m_es not works because of 'du' cmd
size_m_es=`echo $size_str | cut -d ' ' -f 1`

size_m_line=`df -m | grep overlay | tr -s ' '`

total_size_m=`echo $size_m_line | cut -d' ' -f2`
avail_size_m=`echo $size_m_line | cut -d' ' -f4`

cat << EOF
{
    "es_data_size_m": $size_m_es, 
    "total_size_m": $total_size_m, 
    "avail_size_m": $avail_size_m
}
EOF