#!/bin/bash 

cdir=`cd $(dirname $0); pwd`;

export HOMEDIR=$cdir/..

docker-compose -f $HOMEDIR/scripts/docker-compose.yml up -d --force-recreate --remove-orphans
