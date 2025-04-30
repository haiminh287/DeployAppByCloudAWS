variable "vpc_cidr" {
  type = string
  default = "172.16.0.0/16"
}

variable "subnets" {
  description = "Danh sách subnet"
  type = list(object({
    name   = string
    sub_cidr   = string
    availability_zone     = string
    map_public_ip_on_launch = bool
  }))
}
