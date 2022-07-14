variable "image_dump_s3" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "image-dump-s3-cgn-capstone"
}


variable "ec2_instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "Endpoint_Server"
}
