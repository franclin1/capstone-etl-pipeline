### ecsTaskExecutionRole ###

resource "aws_iam_role" "ecsTaskExecutionRole" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2008-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}
resource "aws_iam_role_policy" "ecsTaskExecutionRole" {
  name = "ecsTaskExecutionRole"
  role = aws_iam_role.ecsTaskExecutionRole.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "VisualEditor0"
        Action = [
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

### allow_ecs_upload_to_s3####

resource "aws_iam_role" "allow_ecs_upload_to_s3" {
  name = "allow_ecs_upload_to_s3"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}
resource "aws_iam_role_policy" "upload_image_to_dump_s3_cgn_capstone" {
  name = "upload_image_to_dump_s3_cgn_capstone"
  role = aws_iam_role.allow_ecs_upload_to_s3.id
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "VisualEditor0"
        Action = [
          "s3:PutObject",
        ]
        Effect   = "Allow"
        Resource = "arn:aws:s3:::${var.s3_bucket_name}/*"
      },
    ]
  })
}