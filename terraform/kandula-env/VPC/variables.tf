variable "vpc_cidr" {
  description = "cidr range"
  default = "10.0.0.0/17"
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "database_subnets" {
  type = list(string)
  default = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "private_subnets" {
  type = list(string)
  default = ["10.0.21.0/24", "10.0.22.0/24"]
}


variable "aws_region" {
       description = "The AWS region to create things in."
       default     = "us-east-1"
}



variable "security_group_kandula" {
    description = "Name of security group"
    default     = "kandula-web-sg"
}
variable "security_group_alb" {
    description = "Name of security group"
    default     = "kandula-alb-sg"
}

variable "security_group_database" {
    description = "Name of security group"
    default     = "kandula-database-sg"
}

variable "tag_name" {
    description = "Tag Name of for Ec2 instance"
    default     = "kandula"
}


