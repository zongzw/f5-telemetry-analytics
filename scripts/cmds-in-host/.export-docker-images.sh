#!/bin/bash

cdir=`cd $(dirname $0); pwd`
homedir=$cdir/../..
datadir=$homedir/data/docker_images

compose_file=$homedir/conf.d/docker-compose.yml
image_list=`grep "image:" $compose_file | tr -d ' ' | grep -v "^#" | sed 's/image://'`

(
    cd $datadir
    filelist=images.map
    echo -n > $filelist

    for n in $image_list; do 
        echo $n
        file_name=`echo $n | sed 's/\//_/g' | sed 's/:/_/g'`.tar
        echo "$n|$file_name" >> $filelist
        docker save $n -o $file_name
    done
)

import_sh=$cdir/import-docker-images.sh
cp $import_sh $datadir
