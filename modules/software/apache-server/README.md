# IaC - Infrastructure on AWS
## Apache Server (Private / Public)

Create a Apache Server in a Private or Public Subnet.

![dashboard](images/apache-ec2.png)

Creating a Public Apache Server
```bash
variable private_server {
    type    = bool
    default = false
}
```

Creating a Private Apache Server
```bash
variable private_server {
    type    = bool
    default = true
}

# In the case of a Private Apache Server, a valid CIDR Block for the new Private Subnet it is necessary to be informed
variable cidr_block_private_subnet {
    type = string
    default = "172.31.128.0/20"
}
```
