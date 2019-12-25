#!/bin/bash

cdir=`cd $(dirname $0); pwd`;
export HOMEDIR=$cdir/..

if [ $# -eq 1 -a "$1" = "--demo" ]; then 
    demo=true
    demo_image="ctrlbox"
    demo_yml_option="-f $HOMEDIR/conf.d/.docker-compose-demo.yml"
fi

function refresh_image_if_necessary() {
    
    md5bin=`which md5`
    if [ x"$md5bin" = x ]; then md5bin=`which md5sum`; fi; 

    for n in fluentd $demo_image; do 
        echo generating image: $n; 

        dockerfile_path=$HOMEDIR/docker/$n/Dockerfile
        md5_file=$HOMEDIR/docker/.$n.image.md5
        curmd5=`$md5bin $dockerfile_path | grep -oE "[0-9a-z]{32}"`
        image_name=zongzw/$n:latest
        image_found=`docker images --format "{{.Repository}}:{{.Tag}}" | grep $image_name`

        if [ ! -f $md5_file \
            -o "`cat $md5_file`" != "$curmd5" \
            -o x"$image_found" = x ]; then
            docker build -t $image_name $(dirname $dockerfile_path);
            $md5bin $dockerfile_path | grep -oE "[0-9a-z]{32}" > $md5_file;
        fi
    done
    
}

refresh_image_if_necessary

chmod -R 777 $HOMEDIR/data/* # permission denied in linux.

# docker-compose -f $HOMEDIR/conf.d/docker-compose.yml $demo_yml_option down # force remove and recreate the network
docker-compose -f $HOMEDIR/conf.d/docker-compose.yml $demo_yml_option up -d --force-recreate --remove-orphans

docker exec CTRLBOX "/root/workdir/scripts/cmds-in-ctrlbox/setup-efk.sh"

x='
0. start docker containers..
1. kibana:          import kibana settings
2. elasticsearch:   create index mapping

3. edit .setup.rc.
(. bigip:           create a fake virtual server on bigip)

4. bigip:           create logging irule
5. bigip:           setup bigip virtual server irule

6. ctrlbox          run python http-test.py
'
