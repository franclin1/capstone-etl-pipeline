resource "aws_lambda_function" "extract_transform_load" {
  filename      = "lambda_src_build/etl.zip"
  function_name = "extract_transform_load"
  role          = aws_iam_role.etl_lambda_role.arn
  timeout       = 60
  handler = "lambda_src/lambda_etl.lambda_handler"
  runtime = "python3.9"

  environment {
    variables = {
    s3_bucket_name = var.s3_bucket_name
    dynamoDB_name = var.dynamoDB_name
    }
  }
}
