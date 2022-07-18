variable "vpc_id" {
  description = "Vpc id"
  type = string
}
variable "subnet_ids" {
  description = " subnets id's"
  type = list(string)
}

variable "vpc_cidr" {
  description = "cidr range"
  type = string
}

variable "key_name" {
    description = " SSH keys to connect to ec2 instance"
    type = string
}


variable "instance_type" {
    description = "instance type for ec2"
    type = string
}


variable "acl_value" {
  type = string
}

variable "common_security_group_id" {
    description = "common sg id"
    type = string
}

variable "tag_name" {
    description = "Tag Name of for Ec2 instance"
    type = string
}

variable "ami_id" {
    description = "AMI for linux centos 7"
    type = string
}
variable "ebs_data_type" {
  description = "ebs_data_type"
  type = string
}

variable "ebs_data_size" {
  description = "ebs_data_size"
  type = number
}

variable "allow_cidr_blocks" {
  description = "cidr block allow connections"
  type = list(string)
}

variable "attach_instance_profile" {
  description = "attached profile"
}

variable "create_monitor_server" {}