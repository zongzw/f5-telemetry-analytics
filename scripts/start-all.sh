#!/bin/bash

cdir=`cd $(dirname $0); pwd`;
export HOMEDIR=$cdir/..

if [ $# -eq 1 -a "$1" = "--demo" ]; then
    demo_yml_option="-f $HOMEDIR/conf.d/.docker-compose-demo.yml"
fi

function refresh_image_if_necessary() {
    
    md5bin=`which md5`
    if [ x"$md5bin" = x ]; then md5bin=`which md5sum`; fi; 

    for n in fluentd ctrlbox; do 
        echo "Generating image: $n ..."

        dockerfile_path=$HOMEDIR/docker/$n/Dockerfile
        md5_file=$HOMEDIR/docker/.$n.image.md5
        curmd5=`$md5bin $dockerfile_path | grep -oE "[0-9a-z]{32}"`
        image_name=f5networks/$n:latest
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
rm -rf $HOMEDIR/data/kafka/* # remove legacy kafka data for no persistence.

# docker-compose -f $HOMEDIR/conf.d/docker-compose.yml $demo_yml_option down # force remove and recreate the network
docker-compose -f $HOMEDIR/conf.d/docker-compose.yml $demo_yml_option up -d --force-recreate --remove-orphans

sleep 1
docker ps | grep "CTRLBOX" > /dev/null
if [ $? -ne 0 ]; then echo "CTRLBOX not found, cannot forward, quit."; exit 1; fi
docker ps | grep "FLUENTD" > /dev/null
if [ $? -ne 0 ]; then echo "FLUENTD not found, cannot forward, quit."; exit 1; fi

docker exec CTRLBOX "/root/workdir/scripts/cmds-in-ctrlbox/setup-efk.sh"

echo "Setup self control and monitor system."
docker exec CTRLBOX "crond"
docker exec CTRLBOX crontab /etc/crontab

echo "Setup fluentd auto reload for configuration changes(per min)."
docker exec FLUENTD "crond"
docker exec FLUENTD crontab /etc/crontab

# x='
# 0. start docker containers..
# 1. kibana:          import kibana settings
# 2. elasticsearch:   create index mapping

# 3. edit .setup.rc.
# (. bigip:           create a fake virtual server on bigip)

# 4. bigip:           create logging irule
# 5. bigip:           setup bigip virtual server irule

# 6. ctrlbox          run python http-test.py
# '
