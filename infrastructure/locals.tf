data "aws_caller_identity" "current" {}
data "aws_ecr_authorization_token" "token" {}

locals {
    account_id = data.aws_caller_identity.current.account_id
    aws_ecr_url = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com"
}