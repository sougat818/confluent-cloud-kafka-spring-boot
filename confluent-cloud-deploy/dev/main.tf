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

resource "confluentcloud_api_key" "provider_dev" {
  cluster_id     = confluentcloud_kafka_cluster.test.id
  environment_id = confluentcloud_environment.environment.id
}