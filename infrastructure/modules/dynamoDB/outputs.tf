output "dynamoDB_name" {
  description = "Name of my dynamoDB"
  value       = aws_dynamodb_table.basic-dynamodb-table.name
}
output "dynamoDB_arn" {
  description = "ARN of my dynamoDB"
  value       = aws_dynamodb_table.basic-dynamodb-table.arn
}
