terraform {
    #required_version = "~> 1.1.8"
    required_version = ">= 0.14.9"
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = ">=2.7.1"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.70"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.1.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.1.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.2.0"
    }

  }
  backend "s3" {
    bucket = "terraform-state-kandula"
    key    = "instances/instances_terraform.tfstate"
    region = "us-east-1"
    }
  }


provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      owner = "sigalits"
      env = "ops-school"
      owner-email = "sigalit.hillel@gmail.com"
      application = "Kandula"
      project = "Final"
    }
  }
}

