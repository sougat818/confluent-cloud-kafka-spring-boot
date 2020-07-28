provider "aws" {
  region = "ap-southeast-2"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "sougat818-confluent-cloud-aws-terraform-state"
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
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "sougat818-confluent-cloud-aws-terraform-state-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

terraform {
  backend "s3" {
    bucket         = "sougat818-confluent-cloud-aws-terraform-state"
    key            = "global/s3/terraform.tfstate"
    region         = "ap-southeast-2"
    # Replace this with your DynamoDB table name!
    dynamodb_table = "sougat818-confluent-cloud-aws-terraform-state-locks"
    encrypt        = true
  }
}

provider "confluentcloud" {}

resource "confluentcloud_environment" "environment" {
  name = "dev"
}

resource "confluentcloud_kafka_cluster" "dev" {
  name             = "provider-dev"
  service_provider = "aws"
  region           = "ap-southeast-2"
  availability     = "LOW"
  environment_id   = confluentcloud_environment.environment.id
}
