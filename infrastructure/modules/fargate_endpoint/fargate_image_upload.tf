resource "aws_ecr_repository" "receipt_ident_repository" {
  name                 = "${var.aws_ecr_repository_name}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecs_cluster" "receipt_ident_cluster" {
  name = "receipt_ident_cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_cluster_capacity_providers" "FARGATE" {
  cluster_name = aws_ecs_cluster.receipt_ident_cluster.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

resource "aws_ecs_task_definition" "receipt_upload_endpoint" {
  family                   = "receipt_upload_endpoint"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256 
  memory                   = 512
  task_role_arn            = "${aws_iam_role.allow_ecs_upload_to_s3.arn}"
  execution_role_arn       = "${aws_iam_role.ecsTaskExecutionRole.arn}"
  container_definitions    = <<TASK_DEFINITION
  
[
  {
    "name": "test_repo",
    "image": "${var.aws_caller_identity_current_account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.aws_ecr_repository_name}:latest",
    "cpu": 256,
    "memory": 512,
    "essential": true
  }
]
TASK_DEFINITION

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}

resource "aws_ecs_service" "testservice" {
  name            = "testservice"
  launch_type = "FARGATE"
  cluster         = aws_ecs_cluster.receipt_ident_cluster.id
  task_definition = aws_ecs_task_definition.receipt_upload_endpoint.arn
  desired_count   = 1
  

  network_configuration {
    subnets = ["${var.publicsubnet1_id}","${var.publicsubnet2_id}"]
    security_groups = ["${var.security_group_id}"]
    assign_public_ip = true
  }
}
