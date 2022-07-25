output "s3_bucket_name" {
  description = "S3 Bucket Name for image upload"
  value       = aws_s3_bucket.s3_image_storage.bucket
}
output "s3_bucket_arn" {
  description = "S3 Bucket arn for image upload"
  value       = aws_s3_bucket.s3_image_storage.arn
}
output "s3_bucket_id" {
  description = "S3 Bucket id for image upload"
  value       = aws_s3_bucket.s3_image_storage.id
}