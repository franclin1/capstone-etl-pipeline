resource "aws_s3_bucket" "s3_image_storage" {
  bucket = var.s3_image_storage

  tags = {
    Name        = "Image dump"
  }
}