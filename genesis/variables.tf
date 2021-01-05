variable "environment" {
  type = string
  default = "dev"
}

variable "bucket_s3_state" {
  type = string
  default = "iac-terraform-state-ujr"
}