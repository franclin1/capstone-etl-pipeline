resource "aws_ecr_repository" "receipt_ident_repository" {
  name                 = "receipt_ident_repository"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecs_cluster" "receipt_ident_cluster" {
  name = "receipt_ident_repository"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}



