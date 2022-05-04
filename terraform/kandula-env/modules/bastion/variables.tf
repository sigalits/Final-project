variable "vpc_cidr" {
  description = "cidr range"
  type = string
}

variable "vpc_id" {
  description = "vpc id"
  type = string
}

variable "subnet_ids" {
  description = "private subnets id's"
  type = list(string)
}

variable "az" {
  description = "avaliabilty zone"
  type = list(string)
}


variable "key_name" {
    description = " SSH keys to connect to ec2 instance"
    type = string
}


variable "instance_type" {
    description = "instance type for ec2"
    type = string
}

variable "security_group_bastion" {
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

variable "common_security_group_id" {
  description = "consul sg id"
}
variable "cidr_blocks" {
  description = "cidr block allow connections"
  type = list(string)
}





