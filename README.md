# myserver
ubuntu server setting for kafka

---------------- install kafka ------------------------------------------

1. install JDK 1.8
1.1. download file
     - URL : https://www.oracle.com/java/technologies/downloads/#java8
     - file : jdk-8u341-linux-x64.tar.gz

1.2. unzip file
     - su -
     - cp ~/jdk-8u341-linux-x64.tar.gz /usr/local/
     - cd /usr/local
     - tar -xvzf jdk-8u341-linux-i586.tar.gz
     - ln -s /usr/local/jdk1.8.0_341 java

1.3. add java_home & path
     - vi /etc/profile
      
       export JAVA_HOME=/usr/local/java
       export PATH=$PATH:$JAVA_HOME/bin
       export CLASS_PATH=$JAVA_HOME/lib:$CLASS_PATH

2. modify hosts
     - su -
     - vi /etc/hosts

       192.168.1.81 KAFKA1
       192.168.1.82 KAFKA2
       192.168.1.83 KAFKA3

3. install zookeeper
3.1. download file
     - su -
     - wget https://archive.apache.org/dist/zookeeper/zookeeper-3.8.0/apache-zookeeper-3.8.0-bin.tar.gz
     - cp apache-zookeeper-3.8.0-bin.tar.gz /usr/local/
     - cd /usr/local
     - tar -xvzf apache-zookeeper-3.8.0-bin.tar.gz
     - chown -R ubt apache-zookeeper-3.8.0-bin
     - ln -s /usr/local/apache-zookeeper-3.8.0-bin zookeeper

3.2. setting config
     - cd /usr/local/zookeeper
     - mkdir data
     - echo 1 > data/myid   # each server 1,2,3 ...
     - /usr/local/zookeeper/conf/zoo.cfg
       # change dataDir
       dataDir=/usr/local/zookeeper/data
       # add clusted servers
       server.1=192.168.1.81:2888:3888
       server.2=192.168.1.82:2888:3888
       server.3=192.168.1.83:2888:3888

3.3. add service
     - /usr/local/zookeeper/config/zookeeper.service

       [Unit]
       Description=zookeeper
       Documentation=http://zookeeper.apache.org
       Requires=network.target
       After=network.target

       [Service]
       Type=forking
       User=ubt
       Group=ubt
       SyslogIdentifier=zookeeper
       WorkingDirectory=/usr/local/zookeeper
       Restart=on-failure
       RestartSec=3s
       ExecStart=/usr/local/zookeeper/bin/zkServer.sh start
       ExecStop=/usr/local/zookeeper/bin/zkServer.sh stop
       ExecReload=/usr/local/zookeeper/bin/zkServer.sh restart

       [Install]
       WantedBy=default.target

     - su -
     - ln -s /usr/local/zookeeper/conf/zookeeper.service zookeeper.service
     - systemctl daemon-reload
     - systemctl enable zookeeper.service
     - systemctl start zookeeper.service
     - systemctl status zookeeper.service

4. install kafka
4.1. download file
     - su -
     - wget https://dlcdn.apache.org/kafka/3.2.0/kafka_2.13-3.2.0.tgz
     - cp kafka_2.13-3.2.0.tgz /usr/local/
     - cd /usr/local
     - tar -xvzf kafka_2.13-3.2.0.tgz
     - chown -R ubt kafka_2.13-3.2.0
     - ln -s /usr/local/kafka_2.13-3.2.0 kafka

4.2. setting config
     - /local/kafka/config/server.properties

       # change host.name
       broker.id=1
       host.name=192.168.1.81
       # change Socket Server Settings
       listeners=PLAINTEXT://KAFKA1:9092
       advertised.listeners=PLAINTEXT://192.168.1.81:9092
       # change log path
       log.dirs=/usr/local/kafka/logs
       # change zookeeper setting
       zookeeper.connect=KAFKA1:2181,KAFKA2:2181,KAFKA3:2181
       # chanage Group Coordinator Settings
       delete.topic.enable=true

4.3. change start script
       - /usr/local/kafka/bin/kafka-server-start.sh

         # add JAVA_HOME
         JAVA_HOME=/usr/local/java
         # add PATH java
         PATH=$PATH:$JAVA_HOME/bin

4.4. add service
     - /usr/local/kafka/config/kafka.service

       [Unit]
       Description=kafka
       Documentation=http://kafka.apache.org
       Requires=zookeeper.service
       After=zookeeper.service

       [Service]
       Type=forking
       User=ubt
       Group=ubt
       SyslogIdentifier=kafka
       WorkingDirectory=/usr/local/kafka
       Restart=on-abnormal
       RestartSec=3s
       ExecStart=/usr/local/kafka/bin/kafka-server-start.sh -daemon /usr/local/kafka/config/server.properties
       ExecStop=/usr/local/kafka/bin/kafka-server-stop.sh

       [Install]
       WantedBy=default.target

     - su -
     - ln -s /usr/local/kafka/config/kafka.service kafka.service
     - systemctl daemon-reload
     - systemctl enable kafka.service
     - systemctl start kafka.service
     - systemctl status kafka.service

