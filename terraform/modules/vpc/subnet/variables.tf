variable "vpc_id" {
  type = string
    description = "The ID of the VPC where the subnet will be created."
}

variable "sub_cidr" {
  type = string
    description = "The CIDR block for the subnet."
  
}
variable "availability_zone" {
  type = string
    description = "The availability zone where the subnet will be created."
}

variable "map_public_ip_on_launch" {
  type = bool
    description = "Whether to assign a public IP address to instances launched in the subnet."
  
}

variable "name" {
  type = string
    description = "The name of the subnet."
  
}