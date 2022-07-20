resource "aws_s3_bucket" "s3_image_storage" {
  bucket = var.bucket_name

  tags = {
  Name        = "Image dump"
  }
}
