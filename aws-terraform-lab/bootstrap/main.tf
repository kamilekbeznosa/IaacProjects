provider "aws" {
  region = "eu-central-1"
}

resource "aws_s3_bucket" "rg_terraform_state_5734" {
  bucket = "tf-state-kamilekbeznosa-portfolio"
}

resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.rg_terraform_state_5734.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.rg_terraform_state_5734.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-state-locking"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}