## function

resource "aws_lambda_function" "differentiate_input_images" {
  filename      = "lambda_scr_build/differentiate.zip"
  function_name = "differentiate_input_images"
  role          = aws_iam_role.differentiate_lambda_role.arn
  timeout       = 25
  handler = "lambda_scr/lambda_differentiate.lambda_handler"
  runtime = "python3.9"
}

## allow bucket to invoke lambda
resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.differentiate_input_images.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.s3_image_storage.arn
}

## send bucket notification when item is put into s3
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.s3_image_storage.id

 lambda_function {
    lambda_function_arn = aws_lambda_function.differentiate_input_images.arn
    events              = ["s3:ObjectCreated:*"]
  }
}
