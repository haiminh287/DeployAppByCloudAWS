variable "vpc_id" {
  description = "ID of the VPC to attach the Internet Gateway to"
  type        = string
}

variable "name" {
  description = "Name tag for the Internet Gateway"
  type        = string
}

variable "additional_tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}

variable "environment" {
  type = string
  default = "dev"
}