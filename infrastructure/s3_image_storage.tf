resource "aws_s3_bucket" "image_storage" {
  bucket = var.image_dump_s3

  tags = {
    Name        = "Image dump"
  }
}