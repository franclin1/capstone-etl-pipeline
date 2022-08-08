resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "${var.dynamoDB_name}"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "${var.dynamoDB_hashkey}"
  range_key      = "${var.dynamoDB_sort_key}"

  attribute {
    name = "${var.dynamoDB_hashkey}"
    type = "S"
  }

 attribute {
    name = "${var.dynamoDB_sort_key}"
    type = "S"
  }

  tags = {
    Name        = "dynamodb-table-capstone"
    Environment = "test"
  }
}