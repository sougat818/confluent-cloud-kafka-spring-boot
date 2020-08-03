
terraform_prefix := "terraform-state-file-backend"
terraform_docker := docker run -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} --rm --name $(terraform_prefix) -v ${PWD}:/workspace -w /workspace  $(terraform_prefix)/terraform:latest

.PHONY: init
init:
	docker build . -t $(terraform_prefix)/terraform
	$(terraform_docker) init

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