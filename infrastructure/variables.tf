variable "s3_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "capstonebucketmalte"
}


variable "ec2_instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "Endpoint_Server"
}
