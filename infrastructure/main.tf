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
module "lambda" {
	source = "./modules/lambda_differentiate"
  s3_bucket_name = module.image_storage.s3_bucket_name
  s3_bucket_arn = module.image_storage.s3_bucket_arn
  s3_bucket_id = module.image_storage.s3_bucket_id

}
module "image_storage" {
	source = "./modules/image_storage"
  bucket_name = var.s3_image_storage
}
#module "fargate_endpoint" {
#	source = "./modules/fargate_endpoint"
#  aws_ecr_repository_name = var.aws_ecr_repository_name
#  region = var.region
#}




### Outputs ###
output "s3_bucket_name" {
  description = "S3 Bucket Name for image upload"
  value       = module.image_storage.s3_bucket_name
}
output "s3_bucket_arn" {
  description = "S3 Bucket Name for image upload"
  value       = module.image_storage.s3_bucket_arn
}
output "s3_bucket_id" {
  description = "S3 Bucket Name for image upload"
  value       = module.image_storage.s3_bucket_id
}