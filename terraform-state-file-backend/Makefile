terraform_prefix := "terraform-state-file-backend"

terraform_docker := docker run -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} --rm --name $(terraform_prefix) -v ${PWD}:/workspace -w /workspace  $(terraform_prefix)/terraform:latest
aws_docker := docker run -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} --rm --name aws_docker amazon/aws-cli
jq_docker := docker run -i stedolan/jq 

secrets_arn := $(shell $(aws_docker) --region=ap-southeast-2 secretsmanager describe-secret --secret-id github-sougat818-confluent-cloud-admin | $(jq_docker) -r .ARN)

.PHONY: init
init:
	docker build . -t $(terraform_prefix)/terraform
	$(terraform_docker) init	

.PHONY: import
import:
	$(terraform_docker) import -config=/workspace/ aws_s3_bucket.terraform_state github-sougat818-confluent-cloud-aws-terraform-state
	$(terraform_docker) import -config=/workspace/ aws_secretsmanager_secret.confluent_cloud $(secrets_arn)
	$(terraform_docker) import -config=/workspace/ aws_s3_bucket.terraform_state github-sougat818-confluent-cloud-aws-terraform-state
	$(terraform_docker) import -config=/workspace/ aws_s3_bucket_public_access_block.terraform_state github-sougat818-confluent-cloud-aws-terraform-state
	$(terraform_docker) import -config=/workspace/ aws_dynamodb_table.terraform_locks github-sougat818-confluent-cloud-aws-terraform-state-locks

.PHONY: plan
plan:
	$(terraform_docker) plan

.PHONY: apply
apply:
	$(terraform_docker) apply  -input=false -auto-approve

.PHONY: clean
clean:
	docker rmi $(terraform_prefix)/terraform

.PHONY: destroy
# Not enabled for CI
destroy:
	echo "Not enabled for CI"
	#$(terraform_docker) destroy  -input=false -auto-approve
