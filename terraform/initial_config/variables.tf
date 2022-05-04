variable "aws_region" {
       description = "The AWS region to create things in."
       default     = "us-east-1"
}

variable "tag_name" {
    description = "Tag Name of for Ec2 instance"
    default     = "kandula"
}

variable "remote_state_bucket_name" {
  description = "S3 bucket name for ngnix access.log"
  default =  "terraform-state-kandula"
}
variable "key_name" {
  description = "Pem key file name"
  default = "kandula_key"
}

variable "pem_key_file_name" {
  description = "Pem key file name"
  default = "kandula.pem"
}