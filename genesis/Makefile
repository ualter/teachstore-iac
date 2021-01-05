.DEFAULT_GOAL:=help
SHELL:=/bin/bash
.PHONY: help build test upgrade run

help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m\033[33m\n\nTargets:\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-25s\033[33m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

init: check-env ## Prepare your working directory for other commands, init terraform plan, firing: "terraform init"
	terraform init -backend=false

check-env: # Check environment variables necessary to this Terraform IaC Project
ifndef TF_VAR_environment
	$(error the environment variable TF_VAR_environment is undefined, please set it before: "export TF_VAR_environment=dev")
endif 


plan: check-env ## terraform plan
	terraform plan -out tfplan

apply: plan ## Create or update infrastructure "terraform apply"
	 terraform apply "tfplan"

show: ## Show the current state or a saved plan "terraform show"
	terraform show

validate: ## Check whether the configuration is valid
	terraform validate

destroy: ## Destroy previously-created infrastructure "terraform destroy"
	terraform destroy

chk_bucket: ## Use "terraform console" to show some values of the state of our infrastructure
	echo "aws_s3_bucket.terraform-state-storage-s3.bucket_domain_name" | terraform console

chk_dynamodb: ##  Use "terraform console" to check the state of the DynamoDB created with this terraform infrastructure state
	echo "aws_dynamodb_table.dynamodb-terraform-state-lock" | terraform console	