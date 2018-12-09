#!/bin/bash

#Append cluster IP's to each node
echo "172.31.32.5 kf1
172.31.32.5 zk1
172.31.32.6 kf2
172.31.32.6 zk2
172.31.32.7 kf3
172.31.32.7 zk3" | sudo tee -- append /etc/hosts

sudo cat <<EOF > /var/zookeeper/conf/zoo.conf
# The number of milliseconds of each tick
tickTime=2000
# The number of ticks that the initial
# synchronization phase can take
initLimit=10
# The number of ticks that can pass between
# sending a request and getting an acknowledgement
syncLimit=5
# the directory where the snapshot is stored.
# do not use /tmp for storage, /tmp here is just
# example sakes.
dataDir=/var/lib/zookeeper
# the port at which the clients will connect
clientPort=2181
# the maximum number of client connections.
# increase this if you need to handle more clients
maxClientCnxns=0
# The number of snapshots to retain in dataDir
#autopurge.snapRetainCount=3
# Purge task interval in hours
# Set to "0" to disable auto purge feature
#autopurge.purgeInterval=1
#Cluster network
server.1=zk1:2888:3888
server.2=zk2:2888:3888
server.3=zk3:2888:3888
EOF

sudo rm -rf /var/zookeeper/conf/log4j.properties

sudo cat <<EOF > /var/zookeeper/conf/log4j.properties
# Define some default values that can be overridden by system properties
log4j.rootLogger=INFO, SYSLOG
log4j.appender.SYSLOG=org.apache.log4j.net.SyslogAppender
log4j.appender.SYSLOG.syslogHost=192.168.26.16
log4j.appender.SYSLOG.layout=org.apache.log4j.PatternLayout
log4j.appender.SYSLOG.layout.conversionPattern=%d{ISO8601} %-5p [%t] %c{2} %x - %m%n
log4j.appender.SYSLOG.Facility=LOCAL1
log4j.appender.SYSLOG.Threshold=debug
log4j.appender.SYSLOG.FacilityPrinting=true
EOF

sudo chown ubuntu:ubuntu /var/zookeeper/conf/log4j.properties
sudo chown ubuntu:ubuntu /var/zookeeper/conf/zoo.conf
sudo mkdir /var/lib/zookeeper
sudo chown -R ubuntu:ubuntu /var/lib/zookeeper
