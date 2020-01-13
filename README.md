# bde-over-bigip

This program works on the **Visualization and Analytics over BIG-IP Data Traffic** by using docker based EFK. 'bde' means Big Data Engine.

The scaling-out is an another story, so performance improving work is on the way.

## Program Architecture

![image](https://github.com/zongzw/efk-over-bigip/blob/master/docs/topology.png)

## Running Dependencies

* docker
* docker-compose


## Usage and Workflow

1. Run `start-all.sh`:
   For the first time of running `start-all.sh`, docker command will pull or build images, so it may take a few minutes to finish.

   The `start-all.sh` process do the following 3 things in sequence:
   
   1. Starts the containers: ELASTICSEARCH FLUENTD .. KIBANA and CTRLBOX.
   1. Imports kibana dashboards to KIBANA.
   1. Creates indexs and mappings in ELASTICSEARCH.

2. Setup BIG-IP request logging profile and HSL pool.
   
   To collect logs from BIG-IP virtual servers to EFK, manually, BIG-IP admin needs to

   1. Create HSL pool.

      The pool member is the host where EFK program starts. 
      
      The port is 20001.

   1. Create request logging profile using the HSL pool and bind it to the specific virtual server.

      On the request logging profile creation page, left all configuration as default except *Response Setting* -> *Template*: Use the content of `conf.d/request-logging-template.profile`.

3. Discover and View in Dashboard or Do analytics.

   Open Kibana webpage: http://localhost:5601:

   1. Navigate to Discover tab, to view if there are logs comming in.
   1. Navigate to Dashboard tab for visualization.

      The dashboards can be shared thus embedded in customers' web application via iframe.

      Click *share* to find it.
      
   1. Navigate to Machine Learning tab for data analytics.
