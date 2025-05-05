variable "target_group_arn" {
  description = "The ARN of the target group"
  type        = string
}

variable "target_id" {
  description = "The ID of the target (e.g., EC2 instance ID)"
  type        = string
}

variable "port" {
  description = "The port on which the target is listening"
  type        = number
  default     = 80
}
