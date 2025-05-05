variable "vpc_id" {
  description = "The ID of the VPC where resources will be deployed"
  type        = string
}

variable "target_group_name" {
  description = "Name of the target group"
  type        = string
}

variable "sg_name" {
  description = "Name of the security group"
  type        = string
}

variable "listener_rules" {
  type = list(object({
    from_port = number
    to_port = number
    protocol = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "lb_name" {
  description = "Name of the load balancer"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs to associate with the load balancer"
  type        = list(string)
}

variable "instances" {
  description = "List of instance IDs to attach to the target group"
  type        = list(object({
    id = string
    port = number
  }))
}
