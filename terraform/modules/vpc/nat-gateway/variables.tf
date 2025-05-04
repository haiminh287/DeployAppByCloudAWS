variable "eip_id" {
  type = string
}

variable "subnet_id" {
  description = "ID của subnet nơi NAT Gateway sẽ được tạo"
  type        = string
}

variable "name" {
  description = "Tên của NAT Gateway"
  type        = string
}

variable "additional_tags" {
  type = map(string)
  default = {}
}
