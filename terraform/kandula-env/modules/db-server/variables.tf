variable "vpc_cidr" {
  description = "cidr range"
  type = string
}

variable "vpc_id" {
  description = "vpc id"
  type = string
}

variable "subnet_ids" {
  description = "public subnets id's"
  type = list(string)
}

variable "db_instance_count" {
       description = "Number of instances."
       default     = 2
}

variable "create_dbservers" {
  description = "do we want to create db servers now?"
  type = bool
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

variable "security_group_database" {
    description = "Name of security group"
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

variable "cidr_blocks" {
  description = "cidr block allow connections"
  type = list(string)
}





