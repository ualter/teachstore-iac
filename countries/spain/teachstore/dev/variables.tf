variable "unit" {}
variable "organization" {}
variable "ec2_key_name" {}
variable "vpc_id" {}
variable "public_subnet_ids" {
  type = list
}
variable "region" {}