variable "db_subnet_group_name" {
  description = "Tên của DB Subnet Group"
  type        = string
}

variable "subnet_ids" {
  description = "Danh sách các subnet ID"
  type        = list(string)
}

variable "db_name" {
  description = "Name of the database"
  type        = string
}

variable "username" {
  description = "Master username"
  type        = string
}

variable "password" {
  description = "Master password"
  type        = string
  sensitive   = true
}

variable "vpc_security_group_ids" {
  type = list(string)
}

variable "engine" {
  description = "Database engine"
  type        = string
  default     = "mysql"
}

variable "engine_version" {
  description = "Database engine version"
  type        = string
  default     = "8.0"
}