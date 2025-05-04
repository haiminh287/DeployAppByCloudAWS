# Định nghĩa các biến đầu vào của module
variable "instance_id" {
  type        = string
  description = "ID của EC2 instance để liên kết với Elastic IP"
  default = null
}

variable "network_interface_id" {
  type        = string
  description = "ID của network interface để liên kết với Elastic IP"
  default = null
}

variable "elastic_ip_address" {
  type        = string
  description = "Địa chỉ IP công khai"
  default     = null
}

variable "domain" {
  type        = string
  description = "Chỉ định domain (vpc hoặc standard)"
  default     = "vpc"
}

variable "private_ip" {
  type        = string
  description = "Private IP mà Elastic IP sẽ liên kết"
  default     = null
}

variable "public_ipv4_pool" {
  type        = string
  description = "Pool IP công khai cho Elastic IP"
  default     = "amazon"
}
variable "name" {
  type = string
}

variable "environment" {
  type = string
  default = "dev"
}

variable "additional_tags" {
  type = map(string)
}