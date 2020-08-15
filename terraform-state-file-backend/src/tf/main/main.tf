variable "prefix" {
  type = string
}

provider "aws" {
  region  = "ap-southeast-2"
  version = "~> 3.0"
}

variable "default_tags" {
  default = {
    Cost    = "Confluent"
    Project = "Confluent Cloud Kafka Spring Boot"
  }
  description = "default resource tags"
  type        = map(string)
}

resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "${var.prefix}-terraform-state"
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  tags = merge(
    var.default_tags,
    {
      Env = "dev"
    },
  )

  # This import limitation causes false positives on updates required. Ignoring these fields for now.
  # https://github.com/terraform-providers/terraform-provider-aws/issues/6193
  lifecycle {
    ignore_changes = [
      acl,
      force_destroy
    ]
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "${var.prefix}-terraform-state-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = merge(
    var.default_tags,
    {
      Env = "dev"
    },
  )
}
