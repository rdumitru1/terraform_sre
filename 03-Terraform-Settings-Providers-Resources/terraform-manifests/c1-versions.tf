# Terraform block
terraform {
  required_version = "~> 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Provider block
provider "aws" {
  region  = "eu-west-1"
  profile = "personal"
}

