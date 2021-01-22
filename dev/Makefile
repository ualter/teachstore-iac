.DEFAULT_GOAL:=help
SHELL:=/bin/bash
ANSIBLEDIR:=../ansible
.PHONY: help build test upgrade run

help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m\033[33m\n\nTargets:\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-30s\033[33m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

init: check-env ## Init terraform plan, firing: "terraform init"
	terraform init -backend-config="key=${TF_VAR_environment}/infrastructure.tfstate" \
	               -backend-config="dynamodb_table=terraform_${TF_VAR_environment}_remote_state_lock" \
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
	
kubectl-teachstore-config: ## Config Kubectl to point to AWS EKS Cluster of Application's TeachStore
	aws eks --region $$(terraform output region_spain | sed -e 's/^"//' -e 's/"$$//') update-kubeconfig --name $$(terraform output teachstore_eks_cluster_name | sed -e 's/^"//' -e 's/"$$//')

eks-endpoint: ## Show the EKS Cluster Endpoint at AWS
	terraform output eks_cluster_endpoint

ansible-python-req: ## Check Ansible Kubernetes Collections Python Requirements (Internal use)
	@if pip list | grep openshift; then\
        echo "Python package openshift installed";\
	else\
	    echo "Python Package required for Ansible, not installed, installing now...";\
		pip install --upgrade -r ./ansible/python-requirements.txt;\
    fi

ansible-down-req: ansible-python-req ## Check and Downbload Ansible requirements (roles and collections) (Internal use)
	ansible-galaxy install -r $(ANSIBLEDIR)/requirements.yml 
	ansible-galaxy collection install -r $(ANSIBLEDIR)/requirements.yml

ansible-basic-soft: ansible-down-req kubectl-teachstore-config ## Ansible playbook to install basic softwares at K8s (Metrics Server, Dashboard)
	ansible-playbook -i  $(ANSIBLEDIR)/hosts $(ANSIBLEDIR)/k8s-install-basic-software.yml

ansible-k8sinfo: ## Show Info of K8s EKS, token dashboard URL, etc.
	ansible-playbook -i  $(ANSIBLEDIR)/hosts $(ANSIBLEDIR)/k8s-install-basic-software.yml --tags "k8sinfo"

ansible-elb-controller: ## Install Application Balance Controller at EKS Cluster
	$(eval eks_cluster:=$(shell  kubectl config current-context | sed -e 's/^.*\///g'))
	ansible-playbook -i  $(ANSIBLEDIR)/hosts $(ANSIBLEDIR)/k8s-install-AWSELB-controller.yml  --extra-vars="eks_cluster=$(eks_cluster)"

ansible-install-game: ## Install Game 2048 Sample App (To test AWS ALB)
	$(eval eks_cluster:=$(shell  kubectl config current-context | sed -e 's/^.*\///g'))
	ansible-playbook -i  $(ANSIBLEDIR)/hosts $(ANSIBLEDIR)/k8s-install-game2048-alb-test.yml  --extra-vars="eks_cluster=$(eks_cluster)"

ansible-uninstall-game: ## Uninstall Game 2048 Sample App (Used to test AWS ALB)
	$(eval eks_cluster:=$(shell  kubectl config current-context | sed -e 's/^.*\///g'))
	ansible-playbook -i  $(ANSIBLEDIR)/hosts $(ANSIBLEDIR)/k8s-uninstall-game2048-alb-test.yml  --extra-vars="eks_cluster=$(eks_cluster)"

ansible-install-ngixn: ## Install Ngixn Sample App (To test AWS NLB)
	$(eval eks_cluster:=$(shell  kubectl config current-context | sed -e 's/^.*\///g'))
	ansible-playbook -i  $(ANSIBLEDIR)/hosts $(ANSIBLEDIR)/k8s-install-nginx-nlb-test.yml  --extra-vars="eks_cluster=$(eks_cluster)"	

ansible-uninstall-ngixn: ## Uninstall Ngixn Sample App (To test AWS NLB)
	$(eval eks_cluster:=$(shell  kubectl config current-context | sed -e 's/^.*\///g'))
	ansible-playbook -i  $(ANSIBLEDIR)/hosts $(ANSIBLEDIR)/k8s-uninstall-nginx-nlb-test.yml  --extra-vars="eks_cluster=$(eks_cluster)"	


check-env: # Check environment variables necessary to this Terraform IaC Project
ifndef TF_VAR_environment
	$(error the terraform environment variable TF_VAR_environment is undefined, please set it before. Example: "export TF_VAR_environment=dev")
endif 
