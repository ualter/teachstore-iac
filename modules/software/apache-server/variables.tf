variable region {
    type    = string
    default = "eu-west-3"
}

variable az {
    type    = string
    default = "eu-west-3a"
}

variable ec2_key_pair_name {
    type    = string
    default = "Administrator"
}

variable private_server {
    type    = bool
    default = true
}

variable bastion_source_security_group_id {
  description = "Security Group of Bastion to Allow Connections"
  type        = string
  default     = "sg-0ac26c7bab0c191e9"
}

