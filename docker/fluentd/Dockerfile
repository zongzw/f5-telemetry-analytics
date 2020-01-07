# build with
#   docker build . -t f5networks/fluentd:latest


# ======================================
# ERROR:  While executing gem ... (Gem::FilePermissionError)
#     You don't have write permissions for the /usr/lib/ruby/gems/2.5.0 directory.

# FROM fluent/fluentd:v1.7

# RUN fluent-gem install --install-dir /var fluent-plugin-elasticsearch 
# RUN fluent-gem install fluent-plugin-geoip
# RUN gem update
# RUN fluent-gem install fluent-plugin-elasticsearch

# ======================================

FROM centos:7
RUN yum update -y 
RUN yum install -y sudo vim tree

RUN curl -L https://toolbelt.treasuredata.com/sh/install-redhat-td-agent3.sh | sh

RUN td-agent-gem install fluent-plugin-elasticsearch

RUN yum group install -y "Development Tools"

RUN yum install -y epel-release
RUN yum install -y geoip-devel
RUN td-agent-gem install fluent-plugin-geoip
RUN td-agent-gem install fluent-plugin-kafka
RUN td-agent-gem install fluent-plugin-random
RUN td-agent-gem install fluent-plugin-anonymizer -v 1.0.0
RUN td-agent-gem install fluent-plugin-throttle

ENTRYPOINT /etc/init.d/td-agent start && while true; do sleep 1; done
