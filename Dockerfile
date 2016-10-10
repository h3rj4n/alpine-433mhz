FROM python:3.5-alpine
MAINTAINER Herjan van Eijk <docker@f28.nl>

RUN apk add --no-cache bash

RUN apk add --no-cache linux-headers mosquitto mosquitto-clients wget gcc g++ && \
  pip install spidev && \
  mkdir /treco && \
  wget https://github.com/acekrystal/HomeAutomation/archive/master.zip && unzip master.zip && mv HomeAutomation-master/* /treco/ && \
  rm -rf HomeAutomation-master && \
  apk --no-cache del gcc g++

RUN echo $'spicc\nspidev' >> /etc/modules && \
  echo $'user mosquitto\n\
max_queued_messages 100\n\
port 1883\n\
max_connections -1\n\
protocol mqtt\n\
persistence true\n\
persistence_file mosquitto.db\n\
persistence_location /var/lib/mosquitto\n\
log_dest stderr\n\
log_dest file /var/log/mosquitto/mosquitto.log\n\
log_type error\n\
log_type warning\n\
log_type notice\n\
log_type information\n\
connection_messages true\n\
log_timestamp true\n\
allow_anonymous true' >> /etc/mosquitto/mosquitto.conf

EXPOSE 1883