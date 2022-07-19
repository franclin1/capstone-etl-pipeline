variable "s3_image_storage" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "image-dump-s3-cgn-capstone"
}

variable "aws_ecr_repository_name" {
  description = "Name of the ecr_repository"
  type        = string
  default     = "receipt_ident_repository"
}

variable "region" {
  description = "Default region"
  type = string
  default = "eu-central-1"
}