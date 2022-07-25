resource "aws_iam_role" "etl_lambda_role" {
  name = "etl_lambda_role"

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
resource "aws_iam_role_policy" "allow_textract" {
  name = "allow_textract"
  role = aws_iam_role.etl_lambda_role.id
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "VisualEditor0"
        Action = [
          "textract:AnalyzeExpense",
          "textract:DetectDocumentText"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy" "allow_get_delete_s3" {
  name = "allow_get_delete_on_s3"
  role = aws_iam_role.etl_lambda_role.id
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "VisualEditor0"
        Action = [
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Effect   = "Allow"
        Resource = ["arn:aws:s3:::image-dump-s3-cgn-capstone/*", 
                    "arn:aws:s3:::image-dump-s3-cgn-capstone"
        ]                
      }
    ]
  })
}

resource "aws_iam_role_policy" "allow_dynamoDB_write" {
  name = "allow_dynamoDB_write"
  role = aws_iam_role.etl_lambda_role.id
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "VisualEditor0"
        Action = [
          "dynamoDB:PutItem"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:dynamodb:*:307752819461:table/*"
      },
    ]
  })
}
