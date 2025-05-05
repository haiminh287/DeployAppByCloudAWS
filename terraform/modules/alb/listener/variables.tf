variable "name" {
  description = "Name tag for the listener"
  type        = string
}

variable "load_balancer_arn" {
  description = "ARN of the Load Balancer"
  type        = string
}

variable "port" {
  description = "Port to listen on (e.g. 80, 443)"
  type        = number
  default     = 80
}

variable "protocol" {
  description = "Protocol for listener (HTTP or HTTPS)"
  type        = string
  default     = "HTTP"
}

variable "default_action_type" {
  description = "Action type (e.g. forward, redirect)"
  type        = string
  default     = "forward"
}

variable "target_group_arn" {
  description = "ARN of the Target Group to forward to"
  type        = string
}

variable "additional_tags" {
  description = "Additional tags to apply"
  type        = map(string)
  default     = {}
}
