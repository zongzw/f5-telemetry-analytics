# efk-over-bigip

This program works on the **Visualization and Analytics over BIG-IP Data Traffic** by using docker based EFK.

The scaling-out is an another story, so performance improving work is on the way.

## Program Architecture


## Running Dependencies

* docker
* docker-compose


## Usage and workflow

1. Run `start-all.sh`:
   For the first time of running `start-all.sh`, docker command will pull or build images, so it may take a few minutes to finish.

   The `start-all.sh` process do the following 3 things in sequence:
   
   1. Starts the containers: ELASTICSEARCH FLUENTD KIBANA and CTRLBOX.
   1. Imports kibana dashboards to KIBANA.
   1. Creates indexs and mappings in ELASTICSEARCH.

2. Setup