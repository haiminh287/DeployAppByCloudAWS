variable "subnet_ids" {
  type = list(string)
    description = "List of subnet IDs for the RDS instance"
}

variable "vpc_security_group_ids" {
  type = list(string)
  description = "List of security group IDs for the RDS instance"
  
}