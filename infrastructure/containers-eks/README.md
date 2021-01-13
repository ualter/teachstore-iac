# Provision an EKS Cluster (AWS)

---

## Prerequisites
- AWS CLI - Installed & Configured
- AWS IAM Authenticator - Installed
  - https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html
- kubectl
- wget
---
## "Terraforming"
```bash
1) ~$ terraform init
2) ~$ terraform plan -out tfplan
3) ~$ terraform apply "tfplan"
```
---
## Configure kubectl
```bash
~$ aws eks --region $(terraform output region | sed -e 's/^"//' -e 's/"$//') update-kubeconfig --name $(terraform output cluster_name | sed -e 's/^"//' -e 's/"$//')

### Check
~$ kubectl config get-contexts

### Testing
~$ kubectl get nodes
~$ kubectl get all -ALL
```
---
##  Deploy Kubernetes Metrics Server
The Kubernetes Metrics Server, used to gather metrics such as cluster CPU and memory usage over time, is not deployed by default in EKS clusters.
```bash
### Download it
1) ~$ wget -O v0.3.6.tar.gz https://codeload.github.com/kubernetes-sigs/metrics-server/tar.gz/v0.3.6 && tar -xzf v0.3.6.tar.gz

### Install it on you K8s Clusters (active at kubectl)
2) ~$ kubectl apply -f metrics-server-0.3.6/deploy/1.8+/

### Checking if it is working
3) ~$ kubectl get deployment metrics-server -n kube-system
```
---
## Kubernetes Dashboard
1) Deploy 
```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta8/aio/deploy/recommended.yaml
```
2) "Proxying it"

Now, create a proxy server that will allow you to navigate to the dashboard from the browser on your local machine. This will continue running until you stop the process by pressing ```CTRL + C```.
```bash
~$ kubectl proxy
```
3) Accessing

URL to access the Dashboard:
http://127.0.0.1:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/

4) Authentication 

In another terminal (do not close the ```kubectl proxy```), create the ClusterRoleBinding to use with an authorization token.
```bash
~$ kubectl apply -f https://raw.githubusercontent.com/ualter/learn-terraform-provision-eks-cluster/master/kubernetes-dashboard-admin.rbac.yaml
```
Generate authorization token
```bash
~$ kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep service-controller-token | awk '{print $1}')
```
---


source: https://learn.hashicorp.com/tutorials/terraform/eks