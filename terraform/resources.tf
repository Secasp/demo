provider "aws" {
  access_key = "${var.KEY}"
  secret_key = "${var.SECRET}"
  region     = "${var.REGION}"
}

#Security group
resource "aws_security_group" "sg-addi" {
  name        = "sec-addi"
  description = "Security group for Addi Kafka cluster"

  ingress {
    from_port   = 9092
    to_port     = 9092
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 2181
    to_port     = 2181
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 2888
    to_port     = 2888
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3888
    to_port     = 3888
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

}

data "template_file" "conf1"{
  template = "${file("scripts/kafka1.sh")}"
}

data "template_file" "conf2"{
  template = "${file("scripts/kafka2.sh")}"
}

data "template_file" "conf3"{
  template = "${file("scripts/kafka3.sh")}"
}

#EC2 instace 1 for zookeeper and kafka nodes
resource "aws_instance" "ec2-kafka1" {
  ami             = "${var.ami}"
  instance_type   = "t2.small"
  subnet_id       = "${var.subnet}"
  private_ip      = "${var.privateip1}"
  security_groups = ["${aws_security_group.sg-addi.id}"]
  key_name        = "${var.key}"
  user_data       = "${data.template_file.conf1.rendered}"

  	tags {
	    Name = "kafka_1"
		}

}

#EC2 instace 2 for zookeeper and kafka nodes
resource "aws_instance" "ec2-kafa2" {
  ami             = "${var.ami}"
  instance_type   = "t2.small"
  subnet_id       = "${var.subnet}"
  private_ip      = "${var.privateip2}"
  security_groups = ["${aws_security_group.sg-addi.id}"]
  key_name        = "${var.key}"
  user_data       = "${data.template_file.conf2.rendered}"
  depends_on      = ["aws_instance.ec2-kafka1"]

  	tags {
	    Name = "kafka_2"
		}

}

#EC2 instace 3 for zookeeper and kafka nodes
resource "aws_instance" "ec2-kafka3" {
  ami             = "${var.ami}"
  instance_type   = "t2.small"
  subnet_id       = "${var.subnet}"
  security_groups = ["${aws_security_group.sg-addi.id}"]
  key_name        = "${var.key}"
  private_ip      = "${var.privateip3}"
  user_data       = "${data.template_file.conf3.rendered}"
  depends_on      = ["aws_instance.ec2-kafka1"]
  	tags {
	    Name = "kafka_3"
		}

}
