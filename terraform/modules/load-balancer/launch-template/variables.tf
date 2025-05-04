variable "subnet_id" {
  description = "The ID of the subnet in which to launch the instances"
  type        = string
}

variable "security_groups_ids" {
  description = "A list of security group IDs to associate with the instances"
  type        = list(string)
  
}