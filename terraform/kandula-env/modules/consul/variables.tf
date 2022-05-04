variable "vpc_cidr" {
  description = "cidr range"
  type = string
}

variable "vpc_id" {
  description = "vpc id"
  type = string
}
variable "public_subnet_ids" {
  description = "public subnets id's"
  type = list(string)
}
variable "subnet_ids" {
  description = "private subnets id's"
  type = list(string)
}
variable "create_consul_lb" {
  description = "Do we Want to create LB"
  type = bool
}

variable "create_consul_servers" {
  description = "If to create consul servers"
  type = bool
}
variable "consul_instance_count" {
       description = "Number of instances."
       default     = 3
}

variable "az" {
  description = "avaliabilty zone"
  type = list(string)
}

variable "key_name" {
    description = " SSH keys to connect to ec2 instance"
    type = string
}

variable "assume_role_policy" {
  description = "assume role Policy in json"
}

variable "describe_instances_policy" {
  description = "describe instances policy Policy in json"
}
variable "instance_type" {
    description = "instance type for ec2"
    type = string
}

variable "security_group_consul" {
    description = "Name of security group"
    type = string
}

variable "security_group_common"{
    description = "Name of security group"
    type = string
}
variable "security_group_consul_lb"{
     description = "Name of security group"
    type = string
}
variable "tag_name" {
    description = "Tag Name of for Ec2 instance"
    type = string
}


variable "ami_id" {
    description = "AMI for ubuntu"
    type = string
}

variable "cidr_blocks" {
  description = "cidr block allow connections"
  type = list(string)
}




