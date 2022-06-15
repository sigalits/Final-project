variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  description = "public subnets id's"
  type = list(string)
}
variable "subnet_id" {
  description = "private subnets id's"
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

variable "tag_name" {
    description = "Tag Name of for Ec2 instance"
    type = string
}

variable "ami_id" {
    description = "AMI for ubuntu"
    type = string
}
variable "vpc_cidr" {
}
#variable "jenkins_sg"{
#  type = string
#}
#
#variable "jenkins_lb_sg" {
#  type = string
#}
variable "common_sg" {
  type = string
}

variable "private_ip" {
  description = "permanent private ip for jenkins master"
}

variable "efs_id" {
  description = "Jenkins efs"
}
variable "efs_dns" {
  description = "Jenkins efs dns_name"
}

variable "aws_region" {}

variable "create_lb" {
  description = "Do we Want to create LB"
  type = bool
}

variable "aws_acm_certificate_arn" {
  default = "aws public certificate arn"
}