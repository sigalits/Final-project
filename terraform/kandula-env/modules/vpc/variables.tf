variable "vpc_cidr" {
 type    = string
}

variable "public_subnets" {
  type    = list(string)
}

variable "database_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "tag_name" {
  type = string
}

variable "azs" {
  type = list(string)
}

variable "aws_region" {
       description = "The AWS region to create things in."
}

variable "security_group_common"{
     description = "Name of security group"
    type = string
}