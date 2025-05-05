variable "name" {
  description = "Name of the Load Balancer"
  type        = string
}

variable "internal" {
  description = "Whether the LB is internal"
  type        = bool
  default     = false
}

variable "load_balancer_type" {
  description = "Type of LB (application, network, gateway)"
  type        = string
  default     = "application"
}

variable "security_groups" {
  description = "List of security group IDs"
  type        = list(string)
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "additional_tags" {
  description = "Extra tags to add"
  type        = map(string)
  default     = {}
}
