variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR block for the subnet"
  type        = string
}

variable "availability_zone" {
  description = "Availability Zone for the subnet"
  type        = string
}

variable "map_public_ip_on_launch" {
  description = "Whether to auto-assign public IP to instances in this subnet"
  type        = bool
  default     = false
}

variable "subnet_name" {
  description = "Name tag for the subnet"
  type        = string
}

variable "additional_tags" {
  type = map(string)
}