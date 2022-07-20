### allow differentiate to work####

resource "aws_iam_role" "differentiate_lambda_role" {
  name = "differentiate_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}
resource "aws_iam_role_policy" "allow_detect_text" {
  name = "allow_detect_text"
  role = aws_iam_role.differentiate_lambda_role.id
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "VisualEditor0"
        Action = [
          "rekognition:DetectText",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
resource "aws_iam_role_policy" "allow_get_delete_s3" {
  name = "allow_get_delete_on_s3"
  role = aws_iam_role.differentiate_lambda_role.id
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "VisualEditor0"
        Action = [
          "s3:GetObject",
          "s3:DeleteObject"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:s3:::image-dump-s3-cgn-capstone/*"
      },
    ]
  })
}
resource "aws_iam_role_policy" "lambda_event_access" {
  name = "lambda_event_access"
  role = aws_iam_role.differentiate_lambda_role.id
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "VisualEditor0"
        Action = [
          "lambda:GetEventSourceMapping",
        ]
        Effect   = "Allow"
        Resource = "arn:aws:lambda:*:307752819461:event-source-mapping:${var.s3_bucket_name}"
      },
        {
            Sid= "VisualEditor1",
            Effect= "Allow",
            Action= "lambda:ListEventSourceMappings",
            Resource= "*"
        }
    ]
  })
}
