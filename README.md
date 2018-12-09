## Pre-requisites

You need to install Terraform and Packer binaries. If you are using MAC-OS install them with brew, if you are using linux please visit https://www.packer.io/intro/getting-started/install.html and https://www.terraform.io/intro/getting-started/install.html.

## Infrastructure deployment

    #Init project
    $ cd packer
    #Create a new .env file from .env_example file with your AWS credentials and load the environment variables to your system
    $ source .env
    #Validate the JSON  builder
    $ packer validate kafka_node.json
    #Build the golden AMI
    $ packer build kafka_packer.json

Before the next step, please use the AMI ID created in the last step on the "resources.tf" template located in "terraform/variables.tf".


    #To deploy all the kafka nodes on AWS
    $ cd ../terraform/
    # Create a new .env file from .env_example file with your AWS credentials and load the environment variables to your system
    $ source .env
    #Create you infrastructure Terraform plan
    $ terraform plan -out plan
    #Deploy the new infrastructure you planned one step before
    $ terraform apply plan

    #To destroy your infrastructure
    $ terraform plan -destroy -out destroy
    $ terraform apply destroy


## ZooKeeper launch

Once all the infrastructure is deployed, please use your ".pem" key to access the machines and executes:

    #To start ZooKeeper nodes (Do the same on each node)
    $ cd /var/zookeeper
    $ sudo bin/zkServer.sh start-foreground conf/zoo.conf &
    #Verify the service's health
    $ sudo bin/zkServer.sh status conf/zoo.conf


## Kafka cluster launch

Once zookeeper is runnning on each node, follow these steps to launch Kafka cluster:

    #To start Kafka servers (Do the same on each node)
    $ cd /var/kafka
    $ sudo bin/kafka-server-start.sh config/server.properties &
    #Create a topic
    $ bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 3 --partitions 1 --topic addi-topic
    #Verify that topic is replicated on each node (Do the same on each node)
    $ bin/kafka-topics.sh --describe --zookeeper localhost:2181 --topic addi-topic
    #Send data to the cluster
    $ bin/kafka-console-producer.sh --broker-list localhost:9092 --topic addi-topic
    $ > "send something"
    #Get data from the cluster
    $ bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --from-beginning --topic addi-topic

    After this final step you should be able to see the message "send something" on each node.


## Docs that helped me
 1. https://kafka.apache.org/quickstart
 2. http://labs.sogeti.com/wp-content/uploads/2018/07/PES-Apache-KAFKA-Cluster-SetupAdministrationAWS-V1.0.pdf
 3. https://linuxconfig.org/how-to-install-and-configure-zookeeper-in-ubuntu-18-04
 4. http://www.allprogrammingtutorials.com/tutorials/setting-up-distributed-apache-kafka-cluster.php
 5. https://zookeeper.apache.org/doc/r3.1.2/zookeeperStarted.html#sc_RunningReplicatedZooKeeper
