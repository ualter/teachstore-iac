# IaC - Infrastructure on AWS
## Terraform & Ansible & EKS
![dashboard](https://raw.githubusercontent.com/ualter/teachstore-iac/master/images/dashboard.png)
![eks cluster](https://raw.githubusercontent.com/ualter/teachstore-iac/master/images/overview-eks.png)
![eks workloads](https://raw.githubusercontent.com/ualter/teachstore-iac/master/images/workloads.png)
---
## *Before start...* Prerequisites
- AWS CLI - Installed & Configured
- AWS IAM Authenticator - Installed
  - https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html
- kubectl
- wget
---

## 1) Terraform 
Here, we create and manage all the infrastructure resources in AWS: 
- **Networking** 
  - VPC
  - Subnets
  - Route Tables
  - Internet Gateway
  - NATGateways
  - Elastic IPs
- **Compute**
  - EC2s
  - Security Groups
  - Auto Scaling Groups
  - Launch Configurations
- **Containers**
  - EKS Cluster

### 1.1) First...  the Genesis, *only once!*
First prepare the terraform state environment, **this step should be ran only once**. It will create and prepare all AWS required Services (S3, DynamoDB), necessary to store, share and the locking management of the Terraform state environment created.
```bash
$ cd genesis
$ export TF_VAR_environment=dev
$ make init
$ make apply
```
### 1.2) Start Terraform Infrastructure "Workspace"
Here we start to create the environment itself, for the AWS EKS. This process can be (re)executed anytime and as many times as we need, (re)creating/updating all the environment infrastructure.

1.2.1) Create the State (donwload modules, plugins, etc.).
```bash
#### Inside the main directory (project root)
$ export ENVIRONMENT=dev   # Which environment?
$ make init
```
1.2.2) Create the Plan (to check first what it's gonna be created)
```bash
$ make plan
```
1.2.3) Create the Environment
```bash
$ make apply
```
1.2.3) Point you kubectl to your AWS EKS Kubernetes (kubeconfig creation)

This is important, otherwise your kubectl commands will not work(directed) on EKS.
```bash
$ make kubectl-config-aws
```

---

## 2) Ansible

2.1) Playbook: **k8s-basic-software-playbook.yaml**

In this Ansible playbook, we perform some basic software configuration in our AWS environment:
- **Metrics Server** 
  - Download and install Metrics Server on Kubernetes (EKS)
- **Dashboard**
  - Download and install Kubernetes Dashboard

2.1.1) Install Metrics Server and Dashboard on AWS EKS
```bash
$ make ansible_basic_soft
```
2.1.2) Show EKS K8s info, when you need to recover it
```bash
$ make ansible_k8sinfo
```
2.1.3) Access Dashboard using kubectl proxy via API Server
```bash
#### Let it open (shell session)
$ kubectl proxy 
#### Open in Browser
http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/overview?namespace=default
#### Use token from "make ansible_k8sinfo" for authorization
```

---

#### Check whatelse you can do:
```bash
$ make help
```