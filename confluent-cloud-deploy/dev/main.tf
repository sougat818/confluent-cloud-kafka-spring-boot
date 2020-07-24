provider "confluentcloud" {}

resource "confluentcloud_environment" "environment" {
  name = "dev"
}

resource "confluentcloud_kafka_cluster" "dev" {
  name             = "provider-dev"
  service_provider = "aws"
  region           = "ap-southeast-1"
  availability     = "LOW"
  environment_id   = confluentcloud_environment.environment.id
}
