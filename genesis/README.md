Create the resources (S3 Bucket, DynamoDB Table) for the Terraform to work as Backend (remote).

This is only a support IaC script, to help create the needed resources for Terraform Backend mainly script (root folder), otherwise they have to be created manually.

This is not part of the IaC main Infra, the S3 Bucket and DynamoDB must exist beforehand in order to work the IaC script at the root directory.

Commands:
# Initialized Terraform Project
```bash
export ENVIRONMENT=dev
export TF_VAR_environment=dev
```

#### Initialize resources
```bash
$ terraform init -backend=false
$ terraform apply -target=aws_s3_bucket.terraform-state-storage-s3 -no-color
$ terraform apply -target=aws_dynamodb_table.dynamodb-terraform-state-lock -no-color
```

#### Destroy them
```bash
$ terraform destroy -target=aws_dynamodb_table.dynamodb-terraform-state-lock -no-color
$ terraform destroy -target=aws_s3_bucket.terraform-state-storage-s3 -no-color
```