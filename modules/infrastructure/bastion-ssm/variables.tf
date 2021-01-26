variable "aws_region" {}
variable "unit" {}
variable "name" {}
variable "organization" {}
variable "environment" {}
variable "vpc_id" {}
variable "public_subnets" {}
variable "private_subnets" {}
variable "ec2_key_pair_name" {}

variable "instance_type" {
  type    = string
  default = "t3.nano"
}

variable "create_elastic_ip" {
  default = false
}

variable "elastic_ip_id" {
  default = ""
}

variable "ext_security_groups" {
  description = "External security groups to add to bastion host"
  type        = list(any)
  default     = []
}

variable "ssm_role" {
  type    = string
  default = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

variable "ssh_forward_rules" {
  type        = list(string)
  description = "Rules that will enable port forwarding. SSH Config syntax"
  default     = []
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  description = "List of network subnets that are allowed"
  default = [
    "0.0.0.0/0"
  ]
}

locals {
  name         = "${var.environment}-bastion"
  proxycommand = <<-EOT
    ProxyCommand sh -c "aws ssm start-session --target %h --document-name AWS-StartSSHSession --parameters 'portNumber=%p'"
    EOT
  ssh_config = concat([
    "# SSH over Session Manager",
    "host i-* mi-*",
    local.proxycommand,
  ], var.ssh_forward_rules)
  ssm_document_name = local.name
}