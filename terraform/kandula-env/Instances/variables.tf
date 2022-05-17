variable "ubuntu_account_number" {
  description = "Ubuntu formal account"
  default = "099720109477"
}
variable "vpc_cidr" {
  description = "cidr range"
  default = "10.0.0.0/17"
}

variable "aws_region" {
       description = "The AWS region to create things in."
       default     = "us-east-1"
}

variable "create_lb" {
  description = "Do we Want to create LB"
  type = bool
  default = true
}
variable "create_consul_lb" {
  description = "Do we Want to create LB"
  type = bool
  default = true
}


variable "kandula_instance_count" {
       description = "Number of instances."
       default     = 1
}

variable "db_instance_count" {
       description = "Number of instances."
       default     = 1
}

variable "consul_instance_count" {
       description = "Number of instances."
       default     = 3
}

variable "key_name" {
    description = " SSH keys to connect to ec2 instance"
    default     = "kandula_key"
}

variable "jenkins_key_name" {
    description = "SSH keys to connect to ec2 instance"
    default     = "sigal_jenkins_ec2_key"
}


variable "force_destroy" {
  description = "to enable force destory on s3 bucket"
  type = bool
  default = false
}

variable "create_consul_servers" {
  description = "do we want to create db servers now?"
  type = bool
  default = true
}
variable "instance_type" {
    description = "instance type for ec2"
    default     =  "t2.micro"
}

variable "security_group_kandula" {
    description = "Name of security group"
    default     = "kandula-sg"
}
variable "security_group_alb" {
    description = "Name of security group"
    default     = "kandula-alb-sg"
}

variable "security_group_database" {
    description = "Name of security group"
    default     = "kandula-database-sg"
}

variable "security_group_consul_lb"{
     description = "Name of security group"
     default = "kandula-consul_lb-sg"
}

variable "security_group_consul" {
    description = "Name of security group"
    default     = "kandula-consul-sg"
}

variable "security_group_jenkins_lb" {
    description = "Name of security group"
    default     = "kandula-jenkins-lb-sg"
}


variable "security_group_bastion" {
    description = "Name of security group"
    default     = "kandula-bastion-sg"
}
variable "tag_name" {
    description = "Tag Name of for Ec2 instance"
    default     = "kandula"
}

variable "ebs_data_type" {
  description = "ebs_data_type"
  default     = "gp2"
}

variable "ebs_data_size" {
  description = "ebs_data_size"
  default     = 10
}

variable "cidr_blocks" {
  description = "cidr block allow connections"
  type = list(string)
  default = ["0.0.0.0/0", "62.219.143.165/32"]
  #default = ["10.1.10.0/23","10.1.2.0/23","10.1.0.0/23","10.164.0.0/16","192.168.20.0/24","10.165.0.0/18",
  #    "10.126.0.0/20","172.16.0.0/16","10.100.8.0/22","192.168.0.0/16","62.219.143.165/32"]
}

variable "acl_value" {
    default = "private"
}

variable "jenkins_bucket_name" {
  description = "S3 bucket name for kandula log"
  default = "kandul-jenkins-backup"
}

variable "bucket_name" {
  description = "S3 bucket name for kandula log"
  default = "kandula-log"
}

variable "consul_ami_id" {
  description = "Ubuntu 21.10 ami"
  default = "ami-0fcda042dd8ae41c7"
}

variable "jenkins_nodes_count" {
  description = "Number of Jenkins nodes"
  default = 2
}

variable "jenkins_node_private_ip"{
  description = "List of private ip's for Jenkins nodes"
  default = ["10.0.21.10","10.0.22.10"]
}

variable "jenkins_server_private_ip"{
  description = "List of private ip's for Jenkins nodes"
  default = "10.0.21.21"
}


