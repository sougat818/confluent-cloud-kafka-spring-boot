provider "aws" {
  region = "ap-southeast-2"
}

#import -config=/workspace/confluent-cloud-deploy/dev  aws_s3_bucket.terraform_state sougat818-confluent-cloud-aws-terraform-state
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

#import -config=/workspace/confluent-cloud-deploy/dev  aws_dynamodb_table.terraform_locks sougat818-confluent-cloud-aws-terraform-state-locks
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "sougat818-confluent-cloud-aws-terraform-state-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

#import -config=/workspace/confluent-cloud-deploy/dev aws_secretsmanager_secret.confluent_cloud arn:aws:secretsmanager:ap-southeast-2:439904798018:secret:confluent_cloud-HPCUM6

resource "aws_secretsmanager_secret" "confluent_cloud" {
  name = "confluent_cloud"
  recovery_window_in_days = 30
  description = "key and secret for confluent cloud with cluster creation access"
}

data "aws_secretsmanager_secret_version" "confluent_cloud" {
  secret_id = "${aws_secretsmanager_secret.confluent_cloud.id}"
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

provider "confluentcloud" {
    username = jsondecode(data.aws_secretsmanager_secret_version.confluent_cloud.secret_string)["confluent_cloud_key"]
    password = jsondecode(data.aws_secretsmanager_secret_version.confluent_cloud.secret_string)["confluent_cloud_secret"]
}

resource "confluentcloud_environment" "environment" {
  name = "dev"
}

resource "confluentcloud_kafka_cluster" "dev" {
  name             = "provider-dev"
  service_provider = "aws"
  region           = "ap-southeast-2"
  availability     = "LOW"
  environment_id   = confluentcloud_environment.environment.id
  deployment       = {
                       "sku" = "BASIC"
                     }
  network_egress   = 100
  network_ingress  = 100
  storage          = 5000
}
