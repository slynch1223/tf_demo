resource "aws_kms_key" "dynamo_db_kms" {
  enable_key_rotation = true
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "tf-state-locking"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  point_in_time_recovery {
    enabled = false
  }

  server_side_encryption {
    enabled     = true
    kms_key_arn = aws_kms_key.dynamo_db_kms.arn
  }
}
