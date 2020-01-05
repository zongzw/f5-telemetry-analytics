#!/bin/bash

cdir=`cd $(dirname $0); pwd`
workdir=$cdir/../../..

es_data_dir=$workdir/data/elasticsearch
kfk_data_dir=$workdir/data/kafka

size_str=`du -sm $es_data_dir` # inline this line to size_m_es not works because of 'du' cmd
size_m_es=`echo $size_str | cut -d ' ' -f 1`
size_str=`du -sm $kfk_data_dir`
size_m_kfk=`echo $size_str | cut -d ' ' -f 1`

size_m_line=`df -m | grep overlay | tr -s ' '`

total_size_m=`echo $size_m_line | cut -d' ' -f2`
avail_size_m=`echo $size_m_line | cut -d' ' -f4`

usage_rate=$((100 * ($total_size_m - $avail_size_m) / $total_size_m))

cat << EOF
{
    "es_data_size_m": $size_m_es,
    "kfk_data_size_m": $size_m_kfk,
    "total_size_m": $total_size_m, 
    "avail_size_m": $avail_size_m,
    "usage_rate": $usage_rate
}
EOF