variable "region" {
  description = "Default region"
  type = string
}
variable "s3_bucket_name" {
  description = "s3_image_storage"
  type        = string
}
variable "aws_ecr_repository_name" {
  description = "Name of the ecr_repository"
  type        = string
}
variable "aws_caller_identity_current_account_id" {
  description = "aws_caller_identity_current_account_id"
  type        = string
}
variable "publicsubnet1_id" {
  description = "publicsubnet1"
  type        = string
}
variable "publicsubnet2_id" {
  description = "publicsubnet2"
  type        = string
}
variable "security_group_id" {
  description = "sec group"
  type        = string
}
variable "dynamoDB_arn" {
  description = "ARN of my dynamoDB"
  type = string 
}