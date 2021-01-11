############# VPC
resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr_block
    assign_generated_ipv6_cidr_block = false
    enable_dns_hostnames             = true
    enable_dns_support               = true

    tags =  merge({
        Name           = var.name
        "organization" = var.organization
        "unit"         = var.unit
    },
       var.tags_vpc
    )
}

############# Internet Gateway
resource "aws_internet_gateway" "public" {
    vpc_id = aws_vpc.main.id

    tags = {
    "organization" = var.organization
  }
}

############# Routing
resource "aws_default_route_table" "main" {
    default_route_table_id = aws_vpc.main.default_route_table_id

    tags = {
        Name           = "default"
        "organization" = var.organization
    }
}
resource "aws_route" "internet_gateway_ipv4" {
  route_table_id         = aws_default_route_table.main.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.public.id
}
/*resource "aws_route" "internet_gateway_ipv6" {
  route_table_id              = aws_default_route_table.main.id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_internet_gateway.public.id
}*/

############# Subnets
data "aws_availability_zones" "available" {}

##### Public Subnets

resource "aws_subnet" "public" {
    count             = length(data.aws_availability_zones.available.names)
    vpc_id            = aws_vpc.main.id
    availability_zone = data.aws_availability_zones.available.names[count.index]

    cidr_block                      = var.public_subnet_cidr_block[count.index]
    #cidr_block                      = cidrsubnet(var.public_subnet_cidr_block, 4, count.index)
    #ipv6_cidr_block                 = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, count.index)
    #assign_ipv6_address_on_creation = true
    map_public_ip_on_launch         = true

    tags =  merge({
        Name           = var.name
        "organization" = var.organization
        "unit"         = var.unit
    },
       var.tags_public_subnet
    )

    lifecycle {
      ignore_changes = [availability_zone]
    }
}


##### Private Subnets
resource "aws_subnet" "private" {
    count             = length(data.aws_availability_zones.available.names)
    vpc_id            = aws_vpc.main.id
    availability_zone = data.aws_availability_zones.available.names[count.index]

    cidr_block                      = var.private_subnet_cidr_block[count.index]
    #cidr_block                      = cidrsubnet(var.private_subnet_cidr_block, 4, count.index)
    #ipv6_cidr_block                 = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, count.index)
    #assign_ipv6_address_on_creation = false
    map_public_ip_on_launch         = false

     tags =  merge({
        Name           = var.name
        "organization" = var.organization
        "unit"         = var.unit
    },
       var.tags_private_subnet
    )

    lifecycle {
      ignore_changes = [availability_zone]
    }
}