resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "Positions"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "Id"
  range_key      = "Invoice_No"

  attribute {
    name = "Id"
    type = "S"
  }

 attribute {
    name = "Invoice_No"
    type = "S"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }

  tags = {
    Name        = "dynamodb-table-capstone"
    Environment = "test"
  }
}