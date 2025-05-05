variable "name" {
  description = "Name of the target group"
  type        = string
}

variable "port" {
  description = "Port for the target group"
  type        = number
  default     = 80
}

variable "protocol" {
  description = "Protocol for the target group (HTTP or HTTPS)"
  type        = string
  default     = "HTTP"
}

variable "vpc_id" {
  description = "VPC ID to associate with the target group"
  type        = string
}

# Health check variables
variable "health_check_path" {
  type        = string
  default     = "/"
}

variable "health_check_protocol" {
  type        = string
  default     = "HTTP"
}

variable "health_check_interval" {
  type        = number
  default     = 30
}

variable "health_check_timeout" {
  type        = number
  default     = 5
}

variable "healthy_threshold" {
  type        = number
  default     = 2
}

variable "unhealthy_threshold" {
  type        = number
  default     = 2
}

variable "additional_tags" {
  description = "Extra tags to apply"
  type        = map(string)
  default     = {}
}