#!/bin/bash

mapfile=images.map
if [ ! -f $mapfile ]; then 
    echo "The file $mapfile not found."
    exit 1
fi

for n in `cat $mapfile`; do 
    docker_name=`echo $n | cut -d '|' -f 1`
    docker_file=`echo $n | cut -d '|' -f 2`

    if [ ! -f "$docker_file" ]; then
        echo "docker image $docker_file for $docker_name not found."
        continue
    fi

    docker import $docker_file $docker_name
done
