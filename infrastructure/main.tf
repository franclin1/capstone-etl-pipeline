terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.19.0"
    }
  }
  backend "s3" {
    bucket = "capstone-bucket-malte-cgn-tf-state"
    key    = "terraform.tfstate"
    region = "eu-central-1"
  }
  required_version = ">= 0.14.9"
}


### Modules ####
module "dynamoDB" {
	source = "./modules/dynamoDB"
  dynamoDB_name = var.dynamoDB_name
  dynamoDB_hashkey = var.dynamoDB_hashkey
  dynamoDB_sort_key = var.dynamoDB_sort_key
}
module "lambda_etl" {
	source = "./modules/lambda_etl"
  s3_bucket_name = module.image_storage.s3_bucket_name
  dynamoDB_arn = module.dynamoDB.dynamoDB_arn
  s3_bucket_arn = module.image_storage.s3_bucket_arn
}
module "lambda_differentiate" {
	source = "./modules/lambda_differentiate"
  s3_bucket_name = module.image_storage.s3_bucket_name
  s3_bucket_arn = module.image_storage.s3_bucket_arn
  s3_bucket_id = module.image_storage.s3_bucket_id
  etl_function_arn = module.lambda_etl.etl_function_arn
  region = var.region
  account_id = local.account_id

  depends_on = [
    module.lambda_etl
  ]
  
}
module "image_storage" {
	source = "./modules/image_storage"
  bucket_name = var.s3_image_storage
}
module "vpc" {
  source = "./modules/vpc"
}
module "fargate_endpoint" {
	source = "./modules/fargate_endpoint"
  aws_ecr_repository_name = var.aws_ecr_repository_name
  region = var.region
  s3_bucket_name = module.image_storage.s3_bucket_name
  aws_caller_identity_current_account_id = data.aws_caller_identity.current.account_id
  publicsubnet1_id = module.vpc.publicsubnet1_id
  publicsubnet2_id = module.vpc.publicsubnet2_id
  security_group_id = module.vpc.security_group_id
  dynamoDB_arn =  module.dynamoDB.dynamoDB_arn
  dynamoDB_name = module.dynamoDB.dynamoDB_name
}

