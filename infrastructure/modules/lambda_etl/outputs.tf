output "etl_function_arn" {
  description = "Arn of etl_lambda"
  value       = aws_lambda_function.extract_transform_load.arn
}