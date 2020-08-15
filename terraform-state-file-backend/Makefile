prefix := com-github-sougat818-confluent-cloud-aws
region := ap-southeast-2

.PHONY: init
init:
	@terraform init	

.PHONY: import
import:
	@terraform import -config=. aws_s3_bucket.terraform_state $(prefix)-terraform-state > /dev/null 2>&1 || echo "Assuming new environment creation for s3 bucket"
	@terraform import -config=. aws_s3_bucket_public_access_block.terraform_state $(prefix)-terraform-state  > /dev/null 2>&1 || echo "Assuming new environment creation for s3 bucket access"
	@terraform import -config=. aws_dynamodb_table.terraform_locks $(prefix)-terraform-state-locks  > /dev/null 2>&1 || echo "Assuming new environment creation for dynamodb"

.PHONY: plan
plan:
	@terraform plan -var="prefix=$(prefix)"

.PHONY: apply
apply:
	@terraform apply -var="prefix=$(prefix)" -input=false -auto-approve

.PHONY: destroy
# Not enabled for CI
destroy:
	@terraform destroy -var="prefix=$(prefix)" -input=false -auto-approve
