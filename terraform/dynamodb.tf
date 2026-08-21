resource "aws_dynamodb_table" "visitors" {
  name         = "cloudresume-visitors"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }
}