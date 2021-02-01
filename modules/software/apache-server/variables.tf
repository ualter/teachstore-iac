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

# When true the Apache Server will be installed in a Private Subnet (created here), also:
# - must be informed a valid CIDR Block (available) in the VPC where it's gonna be
# - must be informed a NAT Gateway using the Subnet Id where it is localized (otherwise without outbound connection to internet, the Apache Server service won't be installed properly)
# - must be informed the Security Group Id of the Bastion Server, the "security entry-point", in order to allow access inside the Cloud, inside the VPC (private connections)
variable private_server {
    type    = bool
    default = true
}

variable "private_subnet_cidr_block" {
  type = string
  description = "The CIDR Block for the new Private Subnet (when requested)"
  default = "172.31.96.0/20"
}

variable "nat_gateway_subnet_id" {
  type = string
  description = "Subnet where it is installed a NAT Gateway to be used in case a Private Server will be created (needed otherwise 'apt install' will not work)"
  default = "subnet-1d742066"
}

variable bastion_source_security_group_id {
  description = "Security Group of Bastion to Allow Connections when Apache Server is in Private Subnet"
  type        = string
  default     = "sg-0c83086cfd28dc3ea"
}

