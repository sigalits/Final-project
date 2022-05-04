terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.70"
    }
  }
  backend "s3" {
    bucket = "terraform-state-kandula"
    key    = "VPC/vpc_terraform.tfstate"
    region = "us-east-1"
    }
    required_version = ">= 0.14.9"
  }


provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      owner = "sigalits"
      env = "ops-school"
      owner-email = "sigalit.hillel@gmail.com"
      application = "Kandula"
      project = "Mid-Term"
    }
  }
}

