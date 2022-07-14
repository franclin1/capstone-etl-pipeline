terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  backend "s3" {
    bucket = "capstone-bucket-malte-cgn-tf-state"
    key    = "terraform.tfstate"
    region = "eu-central-1"
  }
  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "eu-central-1"   
}

data "aws_caller_identity" "current" {
}

locals {
  account_id = data.aws_caller_identity.current.account_id
}