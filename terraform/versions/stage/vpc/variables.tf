variable "subnets" {
  description = "Danh sách subnet"
  type = list(object({
    name   = string
    sub_cidr   = string
    availability_zone     = string
    map_public_ip_on_launch = bool
  }))
}

variable "vpc_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "i_gateway_name" {
  type = string
}

variable "public_rtb_name" {
  type = string
}

variable "private_rtb_name" {
  type = string
}