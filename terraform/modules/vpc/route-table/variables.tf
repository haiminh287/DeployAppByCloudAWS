variable "vpc_id" {
  type = string
}

variable "internet_gateway_id" {
    type = object({
      cidr_block = string
      gateway_id = string
    })
    default = null
}

variable "nat_gateway_id" {
    type = object({
      cidr_block = string
      nat_gateway_id = string
    })
    default = null
}

# variable "vpn_gateway_id" {}
# variable "transit_gateway_id" {}
# variable "network_interface_id" {}
# variable "vpc_peering_id" {}

variable "route_table_name" { 
  type = string
}

variable "environment" { 
  type = string
  default = "dev"
}

# variable "subnet_id" {
#     type=string
# }

variable "additional_tags" {
  type = map(string)
  default = {}
}