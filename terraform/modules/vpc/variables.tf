variable "vpc_cidr" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "additional_tags" {
  type = map(string)
  default = {}
}