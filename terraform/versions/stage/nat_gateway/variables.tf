variable "elastic_ip_name" {
  description = "Tên tag cho Elastic IP"
  type        = string
}

variable "nat_gateway_name" {
  description = "Tên tag cho NAT Gateway"
  type        = string
}

variable "public_subnet_id" {
  description = "ID của subnet nơi NAT Gateway sẽ được tạo"
  type        = string
}

variable "rtb_privates" {
  type = list(string)
}