## function

resource "aws_lambda_function" "differentiate_input_images" {
  filename      = "lambda_src_build/differentiate.zip"
  function_name = "differentiate_input_images"
  role          = aws_iam_role.differentiate_lambda_role.arn
  timeout       = 60
  handler = "lambda_src/lambda_differentiate.lambda_handler"
  runtime = "python3.9"

  environment {
    variables = {
    s3_bucket_name = var.s3_bucket_name
    etl_function_arn = var.etl_function_arn
    }
  }
}

## allow bucket to invoke lambda
resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.differentiate_input_images.arn
  principal     = "s3.amazonaws.com"
  source_arn    = var.s3_bucket_arn
}

## send bucket notification when item is put into s3
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = var.s3_bucket_id

 lambda_function {
    lambda_function_arn = aws_lambda_function.differentiate_input_images.arn
    events              = ["s3:ObjectCreated:*"]
  }
}
