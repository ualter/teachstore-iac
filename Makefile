.DEFAULT_GOAL:=help
SHELL:=/bin/bash
.PHONY: help build test upgrade run

help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m\033[33m\n\nTargets:\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-25s\033[33m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

init: check-env ## Init terraform plan, firing: "terraform init"
	terraform init -backend-config="key=${ENVIRONMENT}/infrastructure.tfstate" \
	               -backend-config="dynamodb_table=terraform_${ENVIRONMENT}_remote_state_lock" \
	               -get=true -lock=true

plan: check-env ## terraform plan
	terraform plan -out tfplan

apply: plan ## Create or update infrastructure "terraform apply"
	 terraform apply "tfplan"

show: ## Show the current state or a saved plan "terraform show"
	terraform show

output: ## Show all the outputs of this Terraform script (main structure)
	terraform output

refresh: ## Refresh the values of output with the AWS state
	terraform refresh

validate: ## Check whether the configuration is valid
	terraform validate

destroy: ## Destroy previously-created infrastructure "terraform destroy"
	terraform destroy
	
kubectl-config-aws: ## Config Kubectl with the EKS AWS Cluster
	aws eks --region $$(terraform output region_spain | sed -e 's/^"//' -e 's/"$$//') update-kubeconfig --name $$(terraform output eks_cluster_name | sed -e 's/^"//' -e 's/"$$//')

eks-endpoint: ## Show the EKS Cluster Endpoint at AWS
	terraform output eks_cluster_endpoint	

check-env: # Check environment variables necessary to this Terraform IaC Project
ifndef ENVIRONMENT
	$(error the environment variable $$ENVIRONMENT is undefined, please set it before: "export ENVIRONMENT=dev")
endif 
