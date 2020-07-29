provider "aws" {
  region = "ap-southeast-2"
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
