variable "name" {
  description = "Tên của DB Subnet Group"
  type        = string
}

variable "subnet_ids" {
  description = "Danh sách các subnet ID"
  type        = list(string)
}

variable "additional_tags" {
  description = "Tags tùy chọn"
  type        = map(string)
  default     = {}
}
