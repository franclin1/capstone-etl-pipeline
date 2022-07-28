## default
variable "region" {
  description = "Default region"
  type = string
  default = "eu-central-1"
}

## s3 bucket 
variable "s3_image_storage" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "image-dump-s3-cgn-capstone"
}

## ecr
variable "aws_ecr_repository_name" {
  description = "Name of the ecr_repository"
  type        = string
  default     = "receipt_ident_repository"
}

###  dynamoDB
variable "dynamoDB_name" {
  description = "name of used dynamoDB table"
  type = string
  default = "Positions"
}
variable "dynamoDB_hashkey" {
  description = "name of used dynamoDB table"
  type = string
  default = "Id"
}
variable "dynamoDB_sort_key" {
  description = "name of used dynamoDB table"
  type = string
  default = "Invoice_No"
}