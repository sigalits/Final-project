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


####eks
variable "create_eks" {
  default = false
}

variable "eks_instance_types_1"{
  description = "node group1 instance types"
  default = ["t3.medium"]
}

variable "eks_instance_types_2"{
  description = "node group2 instance types"
  default = ["t3.large"]
}

variable "eks_instance_count" {
  description = "instances count per group"
  default = 2
}
variable "kandula_instance_count" {
       description = "Number of instances."
       default     = 1
}

variable "db_instance_count" {
       description = "Number of instances."
       default     = 1
}


variable "key_name" {
    description = " SSH keys to connect to ec2 instance"
    default     = "kandula_key"
}


variable "force_destroy" {
  description = "to enable force destory on s3 bucket"
  type = bool
  default = false
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


variable "bucket_name" {
  description = "S3 bucket name for kandula log"
  default = "kandula-log"
}
####consul
variable "consul_instance_count" {
       description = "Number of instances."
       default     = 3
}

variable "security_group_consul_lb"{
     description = "Name of security group"
     default = "kandula-consul_lb-sg"
}

variable "security_group_consul" {
    description = "Name of security group"
    default     = "kandula-consul-sg"
}

variable "consul_ami_id" {
  description = "Ubuntu 21.10 ami"
  default = "ami-0fcda042dd8ae41c7"
}

variable "create_consul_servers" {
  description = "do we want to create db servers now?"
  type = bool
  default = true
}

variable "create_consul_lb" {
  description = "Do we Want to create LB"
  type = bool
  default = true
}

####jenkins#####

#variable "jenkins_bucket_name" {
#  description = "S3 bucket name for kandula log"
#  default = "kandul-jenkins-backup"
#}

variable "jenkins_key" {
  description = "Jenkins Nodes Pem Keys"
  default = "sigal_jenkins_ec2_key"
}

variable "security_group_jenkins_lb" {
    description = "Name of security group"
    default     = "kandula-jenkins-lb-sg"
}

variable "create_jenkins_servers"{
  type = bool
  default = true
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

variable "jenkins_key_name" {
    description = "SSH keys to connect to ec2 instance"
    default     = "sigal_jenkins_ec2_key"
}

variable "jenkins_nodes_ami" {
  description = "Ubuntu 20.4"
  default = "ami-04505e74c0741db8d"
}


variable "create_lb" {
  description = "Do we Want to create LB"
  type = bool
  default = false
}


######RDS######

variable "instance_name" {
  description = "name for RDS postgres sql db"
  type        = string
  default     = "kanduladb"
}

variable "db_secret_name" {
  description = "identifying name for db secrets in secretsmanager"
  type        = string
  default     = "aws_keys_kandula"
}

variable "db_storage" {
  description = "size of db in gb"
  type        = number
  default     = 10
}

variable "db_engine" {
  description = "engine and version for rds db"
  type        = map(string)
  default = {
    engine  = "postgres"
    version = "12.9"
  }
}

variable "db_instance_class" {
  description = "instance type to be used for db instances"
  type        = string
  default     = "db.t2.micro"
}

variable "db_port" {
  description = "port for db connections"
  type        = number
  default     = 5431
}

variable "ansible_psql_role_vars_filepath" {
  description = "file path for vars file used in ansible psql role"
  type        = string
  default     = "../../../ansible/roles/psql/vars/main.yml"
}

variable "db_setup_script_filepath" {
  description = "file path for sql file used for initial db setup"
  type        = string
  default     = "setup_db.sql"
}

variable "db_pgpass_file_setup" {
  description = "file path for .pgpass"
  type        = string
  default     = ".pgpass"
}

variable "create_rds" {
  default = false
}


####### ELK
variable "elk_instance_count" {
  type    = number
  default = 1
}